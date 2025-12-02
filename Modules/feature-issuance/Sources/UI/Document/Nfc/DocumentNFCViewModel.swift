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

// For some reason, the `@Copyable` macro is acting weird here.
// Doing it manually until resolved.
struct DocumentNFCViewState: ViewState, Copyable {
  let error: ContentErrorView.Config?

  internal func copy(error: ContentErrorView.Config?) -> Self {
      .init(error: error)
  }
}

final class DocumentNFCViewModel<Router: RouterHost>: ViewModel<Router, DocumentNFCViewState> {
  private let interactor: NFCDocumentReaderInteractor
  private let config: DocumentEnrollmentUiConfig

  init(
    router: Router,
    interactor: NFCDocumentReaderInteractor,
    config: DocumentEnrollmentUiConfig
  ) {
    self.interactor = interactor
    self.config = config
    super.init(
      router: router,
      initialState: .init(error: nil)
    )
  }

  func backButtonTapped() {
    router.popTo(with: .featureIssuanceModule(.documentMRZInstruction(config: config)))
  }

  func nextButtonTapped() {
    // Start NFC reading immediately - native NFC dialog will be shown
    startReading()
  }

  func helpLinkTapped() {
    log("Do you need help? link tapped", level: .debug)
  }

  private func startReading() {
    Task {
      guard let mrzKey = config.mrzKey else {
        await MainActor.run {
          setState {
            $0.copy(
              error: .init(
                description: .custom("MRZ key is required for NFC reading"),
                cancelAction: self.onErrorDismissed()
              )
            )
          }
        }
        return
      }

      let result = await interactor.readPassport(mrzKey: mrzKey)

      await MainActor.run {
        switch result {
        case .success(let documentData):
          // Validate that we have the required data
          guard documentData.birthDate != nil,
                documentData.expiryDate != nil,
                documentData.photo != nil else {
            setState {
              $0.copy(
                error: .init(
                  description: .custom(NFCError.missingData.localizedDescription),
                  cancelAction: self.onErrorDismissed()
                )
              )
            }
            return
          }

          // Success - navigate to display screen with data, preserving configId, docTypeIdentifier, and issuerId
          router.push(with: AppRoute.featureIssuanceModule(
            .documentDataDisplay(
              config: DocumentEnrollmentUiConfig(
                mrzKey: mrzKey,
                documentData: DocumentEnrollmentUiConfig.DocumentData(
                  photo: documentData.photo,
                  birthDate: documentData.birthDate,
                  expiryDate: documentData.expiryDate
                ),
                configId: config.configId,
                docTypeIdentifier: config.docTypeIdentifier,
                flowType: config.flowType,
                issuerId: config.issuerId
              )
            )
          ))

        case .failure(let error):
          // Don't show error if user canceled
          guard case .userCanceled = error else {
            setState {
              $0.copy(
                error: .init(
                  description: .custom(error.localizedDescription),
                  cancelAction: self.onErrorDismissed()
                )
              )
            }
            return
          }

          // User canceled - no action needed, native dialog was dismissed
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
