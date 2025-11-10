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
                steps: [(LocalizableStringKey.passportEnrollmentIntroStep1Title, LocalizableStringKey.passportEnrollmentIntroStep1Description),
                                   (LocalizableStringKey.passportEnrollmentIntroStep2Title, LocalizableStringKey.passportEnrollmentIntroStep2Description),
                                   (LocalizableStringKey.passportEnrollmentIntroStep3Title, LocalizableStringKey.passportEnrollmentIntroStep3Description),
                                   (LocalizableStringKey.passportEnrollmentIntroStep4Title, nil),
                                   (LocalizableStringKey.passportEnrollmentIntroStep5Title, nil)],
                config: config
                                  )
    )
  }

  func backButtonTapped() {
    router.pop()
  }

  func startProcedureButtonTapped() {
    router.push(with: .featureIssuanceModule(.documentMRZInstruction(config: viewState.config)))
  }
}
