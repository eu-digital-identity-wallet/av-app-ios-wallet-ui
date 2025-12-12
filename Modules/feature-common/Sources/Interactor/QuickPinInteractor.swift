/*
 * Copyright (c) 2025 European Commission
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
import logic_authentication

public enum QuickPinPartialState: Sendable {
  case success
  case failure(errorMessage: String, attemptsRemaining: Int)
  case lockedOut(lockoutEndTime: TimeInterval)
}

public protocol QuickPinInteractor: Sendable {
  func setPin(newPin: String) async
  func isPinValid(pin: String) async -> QuickPinPartialState
  func changePin(currentPin: String, newPin: String) async -> QuickPinPartialState
  func hasPin() async -> Bool
  nonisolated func isFirstPinIncomplete(_ pin: String, quickPinSize: Int) -> Bool
  nonisolated func validatePinSecurity(_ pin: String) -> LocalizableStringKey?
  func getLockoutStatus() async -> (isLockedOut: Bool, lockoutEndTimeInterval: TimeInterval?)
  nonisolated func isCurrentPinExistInLastUsedPins(pin: String) -> Bool
}

public final actor QuickPinInteractorImpl: @preconcurrency QuickPinInteractor {

  private let pinStorageController: PinStorageController
  private let prefsController: PrefsController

    public init(pinStorageController: PinStorageController, prefsController: PrefsController) {
    self.pinStorageController = pinStorageController
    self.prefsController = prefsController
  }

  public func setPin(newPin: String) {
    pinStorageController.setPin(with: newPin)
    saveUsedPins(pin: newPin)
  }

  public func saveUsedPins(pin: String) {
    var lastUsedPins = (prefsController.getValue(forKey: .lastUsedPins) as? [String]) ?? []
    if lastUsedPins.count == 3 {
      lastUsedPins.removeFirst()
    }
    lastUsedPins.append(pin)
    prefsController.setValue(lastUsedPins, forKey: .lastUsedPins)
  }

  nonisolated public func isCurrentPinExistInLastUsedPins(pin: String) -> Bool {
    guard let usedPins = prefsController.getValue(forKey: .lastUsedPins) as? [String] else {
        return false
    }
    return usedPins.contains(pin)
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
    pinStorageController.retrievePin()?.isEmpty == false
  }

  private func isCurrentPinValid(pin: String) -> QuickPinPartialState {
    let pinValidStatus = pinStorageController.isPinValid(with: pin)
    switch pinValidStatus {
        case .success:
        return .success
      case .failed(let attemptsRemaining):
        let errorMessage = attemptsRemaining > 1 ? LocalizableStringKey.quickPinInvalidWithAttempts(attemptsRemaining).toString :  LocalizableStringKey.quickPinInvalidLastAttempt.toString
        return .failure(errorMessage: errorMessage, attemptsRemaining: attemptsRemaining)
      case .lockedOut(let lockoutEndTimeInterval, _):
        return .lockedOut(lockoutEndTime: lockoutEndTimeInterval)
    }
  }

  nonisolated public func isFirstPinIncomplete(_ pin: String, quickPinSize: Int) -> Bool {
    return pin.count != quickPinSize
  }

  nonisolated private func isSequential(digits: [Int]) -> Bool {
    guard digits.count > 1 else { return false }

    // Check ascending (e.g. 1,2,3,4...)
    let isAscending = zip(digits, digits.dropFirst()).allSatisfy { $1 == $0 + 1 }

    // Check descending (e.g. 6,5,4,3...)
    let isDescending = zip(digits, digits.dropFirst()).allSatisfy { $1 == $0 - 1 }

    return isAscending || isDescending
  }

  public func getLockoutStatus() async -> (isLockedOut: Bool, lockoutEndTimeInterval: TimeInterval?) {
    pinStorageController.getLockoutStatus()
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
