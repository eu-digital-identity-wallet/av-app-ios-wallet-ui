import logic_ui
import logic_resources

@Copyable
struct ChangePinSuccessState: ViewState {

  static var mock: ChangePinSuccessState {
    return ChangePinSuccessState()
  }
}

final class ChangePinSuccessViewModel<Router: RouterHost>: ViewModel<Router, ChangePinSuccessState> {

  init(router: Router) {

      super.init(router: router, initialState: .init())
  }

  func onOkButtonTap() {
      router.popTo(with: .featureAVDashboardModule(.appLanding))
  }
}
