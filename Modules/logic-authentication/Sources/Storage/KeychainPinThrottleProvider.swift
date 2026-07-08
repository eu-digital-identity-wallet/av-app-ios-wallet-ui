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
import logic_business

final class KeychainPinThrottleProvider: PinThrottleProvider {

  private let keyChainController: KeyChainController
  private let authenticationConfig: AuthenticationConfig

  init(
    keyChainController: KeyChainController,
    authenticationConfig: AuthenticationConfig
  ) {
    self.keyChainController = keyChainController
    self.authenticationConfig = authenticationConfig
  }

  func getState() -> PinLockoutState {
    let startedAt = getDouble(forKey: .pinLockoutStartedAt)
    let endsAt = getDouble(forKey: .pinLockoutEndsAt)

    guard endsAt > 0 else {
      return .idle
    }

    let now = Date().timeIntervalSince1970

    guard now < endsAt else {
      return .idle
    }

    let remaining = endsAt - now
    let total = startedAt > 0 ? max(endsAt - startedAt, 0) : remaining

    if startedAt > 0, now < startedAt {
      return .active(remaining: total, total: total)
    }

    return .active(remaining: remaining, total: total)
  }

  func getFailedAttempts() -> Int {
    getInt(forKey: .pinFailedAttempts)
  }

  func recordFailure() -> PinLockoutState {
    let newAttempts = getFailedAttempts() + 1
    let maxAttempts = authenticationConfig.maxFailedPinAttempts

    guard newAttempts >= maxAttempts else {
      setInt(newAttempts, forKey: .pinFailedAttempts)
      return .idle
    }

    let currentLevel = getInt(forKey: .pinLockoutLevel)
    let durations = authenticationConfig.pinLockoutDurations
    let duration = durations.isEmpty ? 0 : durations[min(currentLevel, durations.count - 1)]
    let now = Date().timeIntervalSince1970
    let endsAt = now + duration

    setInt(0, forKey: .pinFailedAttempts)
    setInt(currentLevel + 1, forKey: .pinLockoutLevel)
    setDouble(now, forKey: .pinLockoutStartedAt)
    setDouble(endsAt, forKey: .pinLockoutEndsAt)

    return .active(remaining: duration, total: duration)
  }

  func recordSuccess() {
    setInt(0, forKey: .pinFailedAttempts)
    setInt(0, forKey: .pinLockoutLevel)
    setDouble(0, forKey: .pinLockoutStartedAt)
    setDouble(0, forKey: .pinLockoutEndsAt)
  }
}

private extension KeychainPinThrottleProvider {

  enum KeyIdentifier: String, KeyChainWrapper {

    var value: String { rawValue }

    case pinFailedAttempts
    case pinLockoutLevel
    case pinLockoutStartedAt
    case pinLockoutEndsAt = "lockoutUntil"
  }

  func getInt(forKey key: KeyIdentifier) -> Int {
    guard let raw = keyChainController.getValue(key: key) else { return 0 }
    return Int(raw) ?? 0
  }

  func getDouble(forKey key: KeyIdentifier) -> Double {
    guard let raw = keyChainController.getValue(key: key) else { return 0 }
    return Double(raw) ?? 0
  }

  func setInt(_ value: Int, forKey key: KeyIdentifier) {
    keyChainController.storeValue(key: key, value: String(value))
  }

  func setDouble(_ value: Double, forKey key: KeyIdentifier) {
    keyChainController.storeValue(key: key, value: String(value))
  }
}
