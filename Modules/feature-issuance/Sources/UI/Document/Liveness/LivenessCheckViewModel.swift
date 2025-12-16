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
import SwiftUI
import feature_common
import logic_ui
import logic_resources

@Copyable
struct LivenessCheckViewState: ViewState {
  let instructionPoints: [String]
  let showSuccess: Bool
  let errorConfig: ContentErrorView.Config?
  let isProcessing: Bool
  let config: DocumentEnrollmentUiConfig
}

@MainActor
final class LivenessCheckViewModel<Router: RouterHost>: ViewModel<Router, LivenessCheckViewState> {

  private let interactor: LivenessCheckInteractor

  init(router: Router, config: DocumentEnrollmentUiConfig, interactor: LivenessCheckInteractor) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        instructionPoints: [
          LocalizableStringKey.passportLiveVideoStepFirst.toString,
          LocalizableStringKey.passportLiveVideoStepSecond.toString
        ],
        showSuccess: false,
        errorConfig: nil,
        isProcessing: false,
        config: config
      )
    )
  }

  func backButtonTapped() {
    router.pop()
  }

  private func showError(description: LocalizableStringKey) {
    setState {
      $0.copy(
        errorConfig: ContentErrorView.Config(
          title: .genericErrorTitle,
          description: description,
          button: .tryAgain,
          cancelAction: self.router.pop(),
          action: { [weak self] in
            self?.dismissError()
          }
        ),
        isProcessing: false
      )
    }
  }

  private func dismissError() {
    setState {
      $0.copy(errorConfig: nil)
    }
  }

  func startVerificationTapped() {
    Task {
      await performVerification()
    }
  }

  private func performVerification() async {
    guard let photoData = viewState.config.documentData?.photo else {
      log("No reference image available", level: .error)
      showError(description: .passportLiveVideoErrorNotProcessed)
      return
    }

    setState { $0.copy(isProcessing: true) }

    let result = await interactor.performLivenessCheck(referenceImageData: photoData)

    switch result {
    case .success:
      // Success - show checkmark briefly then navigate to credential issuance
      setState {
        $0.copy(
          showSuccess: true,
          isProcessing: false
        )
      }

      // Wait 1.5 seconds to show the success animation
      try? await Task.sleep(nanoseconds: 1_500_000_000)

      // Navigate to credential issuance screen
      router.push(
        with: AppRoute.featureIssuanceModule(
          .credentialIssuance(config: viewState.config)
        )
      )

    case .failure(let error):
      switch error {
      case .invalidReferenceImage:
        showError(description: .passportLiveVideoErrorNotProcessed)
      case .notLive:
        showError(description: .passportLiveVideoErrorNotLive)
      case .noMatch:
        showError(description: .passportLiveVideoErrorNotMatching)
      case .unableToWriteTempFile:
        showError(description: .passportLiveVideoErrorNotProcessed)
      case .unknown:
        showError(description: .genericErrorDesc)
      }

    case .simulatorNotSupported:
      showError(description: .custom("Liveness check requires a physical iOS device. Please build and run on a real device."))
    }
  }
}
