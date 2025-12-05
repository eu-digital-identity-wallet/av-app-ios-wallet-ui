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
import logic_ui
import logic_resources
import feature_common

@Copyable
struct MrzDocumentInstructionViewState: ViewState {
  let instructionPoints: [String]
  let config: DocumentEnrollmentUiConfig
}

final class MrzDocumentInstructionViewModel<Router: RouterHost>: ViewModel<Router, MrzDocumentInstructionViewState> {
  init(
    router: Router,
    config: DocumentEnrollmentUiConfig
  ) {
    super.init(router: router,
               initialState: .init(instructionPoints: [LocalizableStringKey.passportIdentificationStepFirst.toString,
                                                       LocalizableStringKey.passportIdentificationStepSecond.toString],
                                   config: config))
  }

  func backButtonTapped() {
    router.pop()
  }

  func takeAPhotoTapped() {
    router.push(with: .featureIssuanceModule(.documentMRZScan(config: viewState.config)))
  }
}
