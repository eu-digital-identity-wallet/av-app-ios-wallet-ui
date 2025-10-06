import Foundation
import logic_ui
import logic_resources
import feature_common

@Copyable
struct PassportEnrollmentInstructionViewState: ViewState {
  let instructionPoints: [String]

}

final class PassportEnrollmentInstructionViewModel<Router: RouterHost>: ViewModel<Router, PassportEnrollmentInstructionViewState> {
  init(
    router: Router
  ) {
    super.init(router: router,
               initialState: .init(instructionPoints: [LocalizableStringKey.passportEnrollmentInstructionPoint1.toString,
                                                       LocalizableStringKey.passportEnrollmentInstructionPoint2.toString]))

  }

  func backButtonTapped() {
    router.pop()
  }

  func takeAPhotoTapped() {
    router.push(with: .featureCommonModule(.qrScanner(config: ScannerUiConfig(flow: .presentation))))
  }
}
