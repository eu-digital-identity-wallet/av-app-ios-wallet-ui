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

public enum PinValidationResult {
  case success
  case failed(attemptsRemaining: Int)
  case lockedOut(lockoutEndTimeInterval: TimeInterval, attemptsUsed: Int)
}

public protocol PinStorageController: Sendable {
  func hasPin() -> Bool
  func setPin(with pin: String)
  func isPinValid(with pin: String) -> PinValidationResult
  func getLockoutStatus() -> (isLockedOut: Bool, lockoutEndTimeInterval: TimeInterval?)
}

public final class PinStorageControllerImpl: PinStorageController {
  static let MAX_ATTEMPTS: Int = 4
  static let BASE_LOCKOUT_DURATION: TimeInterval = 60

  private let provider: PinStorageProvider

  public init(provider: PinStorageProvider) {
    self.provider = provider
  }

  public func hasPin() -> Bool {
    provider.hasPin()
  }

  public func setPin(with pin: String) {
    provider.setPin(with: pin)
  }

  public func isPinValid(with pin: String) -> PinValidationResult {
    if provider.isCurrentlyLockedOut() {
      return .lockedOut(
        lockoutEndTimeInterval: provider.getLockoutUntil(),
        attemptsUsed: provider.getFailedAttempts()
      )
    }
    if provider.isPinValid(with: pin) {
      provider.resetFailedAttempts()
      return .success
    } else {
      let newAttemptCount = provider.incrementFailedAttempts()

      if newAttemptCount >= PinStorageControllerImpl.MAX_ATTEMPTS {
        let lockoutDuration = calculateLockoutDuration(attemptCount: newAttemptCount)
        let lockoutUntil = Date.now.timeIntervalSince1970 + lockoutDuration

        provider.setLockoutUntil(timestamp: lockoutUntil)

        return .lockedOut(lockoutEndTimeInterval: lockoutUntil,
                          attemptsUsed: newAttemptCount)
      } else {
        return .failed(attemptsRemaining: PinStorageControllerImpl.MAX_ATTEMPTS - newAttemptCount)
      }
    }
  }

  private func calculateLockoutDuration(attemptCount: Int) -> TimeInterval {
    let multiplier: Int
    switch attemptCount {
      case 4:
        multiplier = 1      // 1 minute
      case 5:
        multiplier = 5      // 5 minutes
      case 6:
        multiplier = 15     // 15 minutes
      case 7:
        multiplier = 60     // 1 hour
      case 8:
        multiplier = 180    // 3 hours
      case 9:
        multiplier = 480    // 8 hours
      default:
        multiplier = attemptCount > 9 ? 480 : 0  // 8 hours for any attempt beyond 9
    }

    return PinStorageControllerImpl.BASE_LOCKOUT_DURATION * Double(multiplier)
  }

  public func getLockoutStatus() -> (isLockedOut: Bool, lockoutEndTimeInterval: TimeInterval?) {
    if provider.isCurrentlyLockedOut() {
      return (true, provider.getLockoutUntil())
    } else {
      return (false, nil)
    }
  }
}
