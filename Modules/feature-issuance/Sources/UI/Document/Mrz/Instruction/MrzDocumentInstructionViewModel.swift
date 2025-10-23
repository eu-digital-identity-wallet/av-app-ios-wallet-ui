import Foundation
import logic_ui
import logic_resources
import feature_common

@Copyable
struct MrzDocumentInstructionViewState: ViewState {
  let instructionPoints: [String]

}

final class MrzDocumentInstructionViewModel<Router: RouterHost>: ViewModel<Router, MrzDocumentInstructionViewState> {
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
    router.push(with: .featureIssuanceModule(.mrzDocumentScan))
  }
}
