import Foundation
import logic_ui
import logic_resources
import feature_common

@Copyable
struct PassportIntroViewState: ViewState {
  let steps: [(LocalizableStringKey, LocalizableStringKey?)]
}

final class PassportIntroViewModel<Router: RouterHost>: ViewModel<Router, PassportIntroViewState> {
  init(
    router: Router
  ) {
    super.init(router: router,
               initialState: .init(
                steps: [(LocalizableStringKey.passportEnrollmentIntroStep1Title, LocalizableStringKey.passportEnrollmentIntroStep1Description),
                                   (LocalizableStringKey.passportEnrollmentIntroStep2Title, LocalizableStringKey.passportEnrollmentIntroStep2Description),
                                   (LocalizableStringKey.passportEnrollmentIntroStep3Title, LocalizableStringKey.passportEnrollmentIntroStep3Description),
                                   (LocalizableStringKey.passportEnrollmentIntroStep4Title, nil),
                                   (LocalizableStringKey.passportEnrollmentIntroStep5Title, nil)]
                                  )
    )
  }

  func backButtonTapped() {
    router.pop()
  }

  func startProcedureButtonTapped() {
    router.push(with: .featureIssuanceModule(.passportEnrollmentInstruction))

  }
}
