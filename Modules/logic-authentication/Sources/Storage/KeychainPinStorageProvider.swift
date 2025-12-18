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
import Foundation
import logic_business
import logic_resources

public final class KeychainPinStorageProvider: PinStorageProvider {

  private let keyChainController: KeyChainController

  public init(keyChainController: KeyChainController) {
    self.keyChainController = keyChainController
  }

  public func retrievePin() -> String? {
    keyChainController.getValue(key: KeyIdentifier.devicePin)
  }

  public func setPin(with pin: String) {
    keyChainController.storeValue(key: KeyIdentifier.devicePin, value: pin)
  }

  public func isPinValid(with pin: String) -> Bool {
    let isValid = keyChainController.getValue(key: KeyIdentifier.devicePin) == pin
    log("Pin validation result: \(isValid)", level: .debug)
    return isValid
  }

  // MARK: - Brute Force Attack Helper Methods

  public func getFailedAttempts() -> Int {
    Int(keyChainController.getValue(key: KeyIdentifier.pinFailedAttempts) ?? "0") ?? 0
  }

  public func incrementFailedAttempts() -> Int {
    let currentAttempts = getFailedAttempts() + 1
    keyChainController.storeValue(key: KeyIdentifier.pinFailedAttempts, value: String(currentAttempts))
    return currentAttempts
  }

  public func resetFailedAttempts() {
    keyChainController.storeValue(key: KeyIdentifier.pinFailedAttempts, value: "0")
    keyChainController.storeValue(key: KeyIdentifier.lockoutUntil, value: "0")
  }

  public func setLockoutUntil(timestamp: TimeInterval) {
    keyChainController.storeValue(key: KeyIdentifier.lockoutUntil, value: String(timestamp))
  }

  public func getLockoutUntil() -> TimeInterval {
    TimeInterval(keyChainController.getValue(key: KeyIdentifier.lockoutUntil) ?? "0") ?? 0
  }

  public func isCurrentlyLockedOut() -> Bool {
    let lockoutUntil = getLockoutUntil()
    return lockoutUntil > 0 && Date.now.timeIntervalSince1970 < lockoutUntil
  }
}

private enum KeyIdentifier: String, KeyChainWrapper {

  public var value: String {
    self.rawValue
  }

  case devicePin
  case pinFailedAttempts
  case lockoutUntil
}
