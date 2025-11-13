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
      case .success:
        setState {
          $0.copy(isProcessing: false, error: nil)
        }

        // Check if this is an ID card (TD1 format) to skip NFC
        let isIDCard = mrzData.mrzType == .td1

        if isIDCard {
//          // For ID cards, skip NFC and go directly to data display with partial data
//          let documentData = DocumentEnrollmentUiConfig.DocumentData(
//            photo: nil,  // No photo without NFC
//            birthDate: mrzData.dateOfBirth,
//            expiryDate: mrzData.expirationDate
//          )
//
//          router.push(with: AppRoute.featureIssuanceModule(
//            .documentDataDisplay(
//              config: DocumentEnrollmentUiConfig(
//                mrzKey: nil,
//                documentData: documentData,
//                configId: viewState.config.configId,
//                docTypeIdentifier: viewState.config.docTypeIdentifier,
//                flowType: .idCard
//              )
//            )
//          ))

          // Show error for ID cards
          setState {
            $0.copy(
              isProcessing: false,
              error: .init(
                description: .custom(""), cancelAction: ()
              )
            )
          }
        } else {
          // For passports (TD3), continue with NFC flow
          let mrzKey = MRZKeyExtractor.extractMRZKey(from: mrzData)

          log("MRZ Key extracted: \(mrzKey) (length: \(mrzKey.count))", level: .info)

          router.push(with: AppRoute.featureIssuanceModule(
            .documentNFC(
              config: DocumentEnrollmentUiConfig(
                mrzKey: mrzKey,
                documentData: nil,
                configId: viewState.config.configId,
                docTypeIdentifier: viewState.config.docTypeIdentifier,
                flowType: .passport
              )
            )
          ))
        }

      case .failure(let error):
        setState {
          $0.copy(
            isProcessing: false,
            error: .init(
              description: .custom(error.localizedDescription),
              cancelAction: { self.onErrorDismissed() }()
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
    // Temporary solution to go back one step when ID card is used.
    router.popTo(with: .featureIssuanceModule(.documentMRZInstruction(config: viewState.config)))
  }

}
