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
import mrz_reader

@Copyable
struct MRZDocumentScanViewState: ViewState {
  let isProcessing: Bool
  let error: ContentErrorView.Config?
  let config: DocumentEnrollmentUiConfig
}

final class MRZDocumentScanViewModel<Router: RouterHost>: ViewModel<Router, MRZDocumentScanViewState> {

  private let interactor: DocumentMRZScanInteractor

  init(
    router: Router,
    interactor: DocumentMRZScanInteractor,
    config: DocumentEnrollmentUiConfig
  ) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        isProcessing: false,
        error: nil,
        config: config
      )
    )
  }

  func backButtonTapped() {
    router.pop()
  }

  func onMRZScanned(mrzData: MRZData) {
    // Prevent multiple scans while processing
    guard !viewState.isProcessing else { return }

    setState { $0.copy(isProcessing: true) }

    Task {
      let result = await Task.detached { () -> MRZProcessingPartialState in
        return await self.interactor.processMRZData(mrzData: mrzData)
      }.value

      switch result {
      case .success(let documentId):
        // TODO: Navigate to success screen with document details
        // For now, just pop back with success
        setState {
          $0.copy(isProcessing: false, error: nil)
        }
        // Calculate MRZ key for NFC reading with proper format including check digits
        let mrzKey = MRZKeyExtractor.extractMRZKey(from: mrzData)

        log("MRZ Key extracted: \(mrzKey) (length: \(mrzKey.count))", level: .info)

        // Navigate to document NFC screen on success, preserving configId and docTypeIdentifier
        router.push(with: AppRoute.featureIssuanceModule(
          .documentNFC(
            config: DocumentEnrollmentUiConfig(
              mrzKey: mrzKey,
              documentData: nil,
              configId: viewState.config.configId,
              docTypeIdentifier: viewState.config.docTypeIdentifier
            )
          )
        ))

      case .failure(let error):
        setState {
          $0.copy(
            isProcessing: false,
            error: .init(
              description: .custom(error.localizedDescription),
              cancelAction: self.onErrorDismissed()
            )
          )
        }
      }
    }
  }

  func onErrorDismissed() {
    setState {
      $0.copy(error: nil)
    }
  }

}
