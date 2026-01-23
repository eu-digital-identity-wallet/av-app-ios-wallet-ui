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
  let formattedBirthDate: String?
  let formattedExpiryDate: String?

  var isValid: Bool {
    !isUnderAge && !isPassportExpired
  }
}

final class DocumentDataDisplayViewModel<Router: RouterHost>: ViewModel<Router, DocumentDataDisplayViewState> {

  init(
    router: Router,
    config: DocumentEnrollmentUiConfig
  ) {
    let isUnderAge = config.documentData?.birthDate.map { MRZDateUtils.isUnderAge($0) } ?? false
    let isPassportExpired = config.documentData?.expiryDate.map { MRZDateUtils.isExpired($0) } ?? false

    let formattedBirthDate = config.documentData?.birthDate.map { MRZDateUtils.formatBirthDate($0) }
    let formattedExpiryDate = config.documentData?.expiryDate.map { MRZDateUtils.formatExpiryDate($0) }

    super.init(
      router: router,
      initialState: .init(
        config: config,
        isUnderAge: isUnderAge,
        isPassportExpired: isPassportExpired,
        formattedBirthDate: formattedBirthDate,
        formattedExpiryDate: formattedExpiryDate
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
}
