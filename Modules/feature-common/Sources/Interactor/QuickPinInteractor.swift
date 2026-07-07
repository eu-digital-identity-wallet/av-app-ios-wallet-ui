/*
 * Copyright (c) 2026 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */
import Foundation
import logic_authentication
import logic_business
import logic_resources

public enum QuickPinPartialState: Sendable {
  case success
  case failure(errorMessage: String, attemptsRemaining: Int)
  case lockedOut(lockoutEndTime: TimeInterval)
}

public protocol QuickPinInteractor: Sendable {
  var maxFailedPinAttempts: Int { get }

  func setPin(newPin: String) async
  func isPinValid(pin: String) async -> QuickPinPartialState
  func changePin(currentPin: String, newPin: String) async -> QuickPinPartialState
  func hasPin() async -> Bool
  nonisolated func isFirstPinIncomplete(_ pin: String, quickPinSize: Int) -> Bool
  nonisolated func validatePinSecurity(_ pin: String) -> LocalizableStringKey?
  func getLockoutStatus() async -> (isLockedOut: Bool, lockoutEndTimeInterval: TimeInterval?)
  func getPinLockoutState() async -> PinLockoutState
  func recordPinFailure() async -> PinLockoutState
  func resetPinThrottle() async
  nonisolated func isCurrentPinExistInLastUsedPins(pin: String) -> Bool
}

public final actor QuickPinInteractorImpl: @preconcurrency QuickPinInteractor {

  private let pinStorageController: PinStorageController
  private let pinThrottleController: PinThrottleController
  private let prefsController: PrefsController

  public let maxFailedPinAttempts: Int

  public init(
    pinStorageController: PinStorageController,
    pinThrottleController: PinThrottleController,
    prefsController: PrefsController
  ) {
    self.pinStorageController = pinStorageController
    self.pinThrottleController = pinThrottleController
    self.prefsController = prefsController
    self.maxFailedPinAttempts = pinThrottleController.maxFailedPinAttempts
  }

  public func setPin(newPin: String) {
    pinStorageController.setPin(with: newPin)
    pinThrottleController.recordSuccess()
    saveUsedPinHashes(pinHash: newPin)
  }

  public func saveUsedPinHashes(pinHash: String) {
    var lastUsedPinHashes = (prefsController.getValue(forKey: .lastUsedPinHashes) as? [String]) ?? []
    if lastUsedPinHashes.count >= 3 {
      lastUsedPinHashes.removeFirst()
    }
    let hashedPin = PinHasher.hash(pin: pinHash)
    lastUsedPinHashes.append(hashedPin)
    prefsController.setValue(lastUsedPinHashes, forKey: .lastUsedPinHashes)
  }

  nonisolated public func isCurrentPinExistInLastUsedPins(pin: String) -> Bool {
    guard let usedPins = prefsController.getValue(forKey: .lastUsedPinHashes) as? [String] else {
        return false
    }
    return usedPins.contains { entry in
      PinHasher.verify(pin: pin, againstStored: entry)
    }
  }

  public func isPinValid(pin: String) -> QuickPinPartialState {
    isCurrentPinValid(pin: pin)
  }

  public func changePin(currentPin: String, newPin: String) -> QuickPinPartialState {

    let pinValidationStatus = isCurrentPinValid(pin: currentPin)
    switch pinValidationStatus {
    case .success:
      setPin(newPin: newPin)
      return pinValidationStatus
    case .failure:
      return pinValidationStatus
    case .lockedOut:
      return pinValidationStatus
    }
  }

  public func hasPin() -> Bool {
    pinStorageController.hasPin()
  }

  private func isCurrentPinValid(pin: String) -> QuickPinPartialState {
    if case .active(let remaining, _) = pinThrottleController.getState() {
      return .lockedOut(lockoutEndTime: Date().timeIntervalSince1970 + remaining)
    }

    if pinStorageController.isPinValid(with: pin) {
      pinThrottleController.recordSuccess()
      return .success
    }

    switch pinThrottleController.recordFailure() {
    case .active(let remaining, _):
      return .lockedOut(lockoutEndTime: Date().timeIntervalSince1970 + remaining)
    case .idle:
      let attemptsRemaining = pinThrottleController.getAttemptsRemaining()
      let errorMessage = attemptsRemaining > 1
      ? LocalizableStringKey.quickPinInvalidWithAttempts(attemptsRemaining).toString
      : LocalizableStringKey.quickPinInvalidLastAttempt.toString
      return .failure(errorMessage: errorMessage, attemptsRemaining: attemptsRemaining)
    }
  }

  nonisolated public func isFirstPinIncomplete(_ pin: String, quickPinSize: Int) -> Bool {
    return pin.count != quickPinSize
  }

  nonisolated private func isSequential(digits: [Int]) -> Bool {
    guard digits.count > 1 else { return false }

    let isAscending = zip(digits, digits.dropFirst()).allSatisfy { $1 == $0 + 1 }
    let isDescending = zip(digits, digits.dropFirst()).allSatisfy { $1 == $0 - 1 }

    return isAscending || isDescending
  }

  public func getLockoutStatus() async -> (isLockedOut: Bool, lockoutEndTimeInterval: TimeInterval?) {
    switch pinThrottleController.getState() {
    case .active(let remaining, _):
      return (true, Date().timeIntervalSince1970 + remaining)
    case .idle:
      return (false, nil)
    }
  }

  public func getPinLockoutState() -> PinLockoutState {
    pinThrottleController.getState()
  }

  public func recordPinFailure() -> PinLockoutState {
    pinThrottleController.recordFailure()
  }

  public func resetPinThrottle() {
    pinThrottleController.recordSuccess()
  }

  nonisolated public func validatePinSecurity(_ pin: String) -> LocalizableStringKey? {

    var error: LocalizableStringKey?

    // All digits same (e.g. 000000, 111111)
    let firstChar = pin.first!
    if pin.allSatisfy({ $0 == firstChar }) {
      error =  .quickPinInvalidGenericError
    }

    // Sequential (ascending or descending, e.g. 123456 or 654321)
    let digits = pin.compactMap { $0.wholeNumberValue }
    if isSequential(digits: digits) {
      error =  .quickPinInvalidGenericError
    }

    // Palindrome (e.g. 123321, 255552, 456654, 159951)
    if pin == String(pin.reversed()) {
      error =  .quickPinInvalidGenericError
    }

    return error
  }
}
