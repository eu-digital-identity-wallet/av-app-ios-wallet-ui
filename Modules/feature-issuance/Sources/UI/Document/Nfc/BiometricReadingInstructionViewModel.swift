import Foundation
import feature_common

@Copyable
struct BiometricReadingInstructionViewState: ViewState {

}

final class BiometricReadingInstructionViewModel<Router: RouterHost>: ViewModel<Router, BiometricReadingInstructionViewState> {
  init(
    router: Router
  ) {
    super.init(router: router,
               initialState: .init()
    )

  }

  func backButtonTapped() {
    router.pop()
  }

  func nextButtonTapped() {

  }

  func helpLinkTapped() {
    debugPrint("Do you need help? link tapped")
  }
}
