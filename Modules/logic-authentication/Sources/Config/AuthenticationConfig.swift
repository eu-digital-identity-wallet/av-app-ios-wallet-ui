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

public protocol AuthenticationConfig: Sendable {
  var maxFailedPinAttempts: Int { get }
  var pinLockoutDurations: [TimeInterval] { get }
}

struct AuthenticationConfigImpl: AuthenticationConfig {

  let maxFailedPinAttempts: Int = 4
  let pinLockoutDurations: [TimeInterval] = [
    60,
    5 * 60,
    15 * 60,
    60 * 60,
    3 * 60 * 60,
    8 * 60 * 60
  ]
}
