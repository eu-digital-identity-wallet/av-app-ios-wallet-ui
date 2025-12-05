import Foundation
import logic_ui
import logic_resources
import feature_common

@Copyable
struct MrzDocumentIntroViewState: ViewState {
  let steps: [(LocalizableStringKey, LocalizableStringKey?)]
  let config: DocumentEnrollmentUiConfig
}

final class MrzDocumentIntroViewModel<Router: RouterHost>: ViewModel<Router, MrzDocumentIntroViewState> {

  init(
    router: Router,
    config: DocumentEnrollmentUiConfig
  ) {
    super.init(router: router,
               initialState: .init(
                steps: [(LocalizableStringKey.passportScanIntroStep1Title, LocalizableStringKey.passportScanIntroStep1Description),
                                   (LocalizableStringKey.passportScanIntroStep2Title, LocalizableStringKey.passportScanIntroStep2Description),
                                   (LocalizableStringKey.passportScanIntroStep3Title, LocalizableStringKey.passportScanIntroStep3Description),
                                   (LocalizableStringKey.passportScanIntroStep4Title, nil),
                                   (LocalizableStringKey.passportScanIntroStep5Title, nil)],
                config: config
                                  )
    )
  }

  func backButtonTapped() {
    router.pop()
  }

  func startProcedureButtonTapped() {
    // Clean up any existing passport photo from a previous flow
    LivenessCheckInteractorImpl.cleanupPassportPhoto()
    router.push(with: .featureIssuanceModule(.documentMRZInstruction(config: viewState.config)))
  }
}
