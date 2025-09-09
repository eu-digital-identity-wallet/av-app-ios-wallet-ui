/*
 * Copyright (c) 2023 European Commission
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
  case lockedOut(lockoutEndTime: TimeInterval, attemptsUsed: Int)
}

public protocol QuickPinInteractor: Sendable {
  func setPin(newPin: String)
  func isPinValid(pin: String) -> QuickPinPartialState
  func changePin(currentPin: String, newPin: String) -> QuickPinPartialState
  func hasPin() -> Bool
}

final class QuickPinInteractorImpl: QuickPinInteractor {

  private let pinStorageController: PinStorageController

  init(pinStorageController: PinStorageController) {
    self.pinStorageController = pinStorageController
  }

  public func setPin(newPin: String) {
    pinStorageController.setPin(with: newPin)
  }

  public func isPinValid(pin: String) -> QuickPinPartialState {
    isCurrentPinValid(pin: pin)
  }

  public func changePin(currentPin: String, newPin: String) -> QuickPinPartialState {

    if case .success = isCurrentPinValid(pin: currentPin) {
      return .success
    } else {
      return .failure(errorMessage: AuthenticationError.quickPinInvalid.localizedDescription, attemptsRemaining: 0)
    }
  }

  public func hasPin() -> Bool {
    return pinStorageController.retrievePin()?.isEmpty == false
  }

  private func isCurrentPinValid(pin: String) -> QuickPinPartialState {
    let pinValidStatus = pinStorageController.isPinValid(with: pin)
    switch pinValidStatus {
        case .success:
        return .success
      case .failed(let attemptsRemaining):
        let errorMessage = attemptsRemaining > 1 ? LocalizableStringKey.quickPinInvalidWithAttempts(attemptsRemaining).toString :  LocalizableStringKey.quickPinInvalidLastAttempt.toString
        return .failure(errorMessage: errorMessage, attemptsRemaining: attemptsRemaining)
      case .lockedOut(let lockoutEndTimeInterval, let attemptsUsed):
        return .lockedOut(lockoutEndTime: lockoutEndTimeInterval, attemptsUsed: attemptsUsed)
    }
  }
}
