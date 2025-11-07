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
import feature_common
import logic_ui

@Copyable
struct DocumentDataDisplayViewState: ViewState {
  let config: DocumentEnrollmentUiConfig
  let isUnderAge: Bool
  let isPassportExpired: Bool

  var isValid: Bool {
    !isUnderAge && !isPassportExpired
  }
}

final class DocumentDataDisplayViewModel<Router: RouterHost>: ViewModel<Router, DocumentDataDisplayViewState> {

  init(
    router: Router,
    config: DocumentEnrollmentUiConfig
  ) {
    let isUnderAge = Self.checkIfUnderAge(birthDate: config.documentData?.birthDate)
    let isPassportExpired = Self.checkIfPassportExpired(expiryDate: config.documentData?.expiryDate)

    super.init(
      router: router,
      initialState: .init(
        config: config,
        isUnderAge: isUnderAge,
        isPassportExpired: isPassportExpired
      )
    )
  }

  func backButtonTapped() {
    router.pop()
  }

  func continueButtonTapped() {
    guard viewState.isValid else { return }
    router.push(with: .featureIssuanceModule(.livenessCheck(config: viewState.config)))
  }

  private static func checkIfUnderAge(birthDate: String?) -> Bool {
    guard let birthDate = birthDate,
          let date = parseMRZDate(birthDate) else {
      return false
    }

    let calendar = Calendar.current
    let now = Date()
    let ageComponents = calendar.dateComponents([.year], from: date, to: now)

    guard let age = ageComponents.year else { return false }
    return age < 18
  }

  private static func checkIfPassportExpired(expiryDate: String?) -> Bool {
    guard let expiryDate = expiryDate,
          let date = parseMRZDate(expiryDate) else {
      return false
    }

    return date < Date()
  }

  private static func parseMRZDate(_ mrzDate: String) -> Date? {
    guard mrzDate.count == 6 else { return nil }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMdd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)

    return formatter.date(from: mrzDate)
  }
}
