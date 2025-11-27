import logic_ui
import logic_resources

@Copyable
struct ChangePinState: ViewState {
  let config: QuickPinUiConfig
  let navigationTitle: LocalizableStringKey
  let title: LocalizableStringKey
  let caption: LocalizableStringKey
  let button: LocalizableStringKey
  let success: LocalizableStringKey
  let successButton: LocalizableStringKey
  let successNavigationType: UIConfig.DeepLinkNavigationType
  let isCancellable: Bool
  let isButtonActive: Bool
  let quickPinSize: Int
  let isLoading: Bool
  var uiPinInputFieldError: LocalizableStringKey?
  var uiPinInputFieldConfirmError: LocalizableStringKey?
  var pin1: String = ""
  var pin2: String = ""
  var showBackButton: Bool = false

  static var mock: ChangePinState {
    return ChangePinState(
      config: QuickPinUiConfig(flow: .set),
      navigationTitle: .custom(""),
      title: .changeQuickPinOption,
      caption: .custom(""),
      button: .quickPinNextButton,
      success: .success,
      successButton: .quickPinSetSuccessButton,
      successNavigationType: .push(screen: .featureAVDashboardModule(.appLanding)),
      isCancellable: false,
      isButtonActive: true,
      quickPinSize: 6,
      isLoading: false,
      uiPinInputFieldError: nil,
      uiPinInputFieldConfirmError: nil
    )
  }
}

final class ChangePinViewModel<Router: RouterHost>: ViewModel<Router, ChangePinState> {

  private var interactor: QuickPinInteractor
  init(router: Router, interactor: QuickPinInteractor, config: any UIConfigType) {

    guard let config = config as? QuickPinUiConfig else {
      fatalError("QuickPinViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    super.init(router: router,
               initialState: .init(
                config: config,
                navigationTitle: config.isSetFlow ? .quickPinConfirmPin : .quickPinConfirmPin,
                title: config.isSetFlow ? .changeQuickPinOption : .changeQuickPinOption,
                caption: config.isSetFlow ? .custom("") : .custom(""),
                button: .quickPinNextButton,
                success: config.isSetFlow ? .quickPinSetSuccess : .quickPinSetSuccess,
                successButton: .quickPinSetSuccessButton,
                successNavigationType: config.isSetFlow
                ? .push(screen: .featureAVDashboardModule(.appLanding))
                : .pop(screen: .featureAVDashboardModule(.appLanding)),
                isCancellable: config.isUpdateFlow,
                isButtonActive: false,
                quickPinSize: 6,
                isLoading: false,
                showBackButton: config.isSetFlow ? false : true
               ))
  }

  func updatePin1(_ pin: String) {
    setState {
      $0.copy(pin1: pin)
    }
  }

  func updatePin2(_ pin: String) {
    setState {
      $0.copy(pin2: pin)
    }
  }

  func validatePinsMatch() {
    if viewState.pin1.isEmpty || viewState.pin2.isEmpty {
      setState {
        $0.copy(uiPinInputFieldConfirmError: .quickPinDoNotMatch)
      }
    } else if viewState.pin1 != viewState.pin2 {
      setState {
          $0.copy(uiPinInputFieldConfirmError: .quickPinDoNotMatch)
      }
    } else if interactor.isCurrentPinExistInLastUsedPins(pin: viewState.pin1) {
        setState {
            $0.copy(uiPinInputFieldConfirmError: .custom("Cant use previous pin"))
        }
    } else {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.onSuccess(self.viewState.pin1)
      }
      setState {
        $0.copy(uiPinInputFieldConfirmError: nil)
      }
    }
  }

  func validateFirstPin() {
    guard viewState.pin1.count == viewState.quickPinSize else {
      return
    }

    let error = interactor.validatePinSecurity(viewState.pin1)

    setState {
      $0.copy(
        uiPinInputFieldError: error
      )
    }
  }

  func isFirstPinIncomplete() {
    if interactor.isFirstPinIncomplete(viewState.pin1, quickPinSize: viewState.quickPinSize) {
      setState {
        $0.copy(uiPinInputFieldError: nil)
      }
    }
  }

  func clearConfirmError() {
    setState {
      $0.copy(uiPinInputFieldConfirmError: nil)
    }
  }

  private func onSuccess(_ pin: String) {

    let interactor = self.interactor
    Task { [weak self] in
      guard let self = self else { return }
      setState { $0.copy(isLoading: true) }
      await interactor.setPin(newPin: self.viewState.pin1)

      self.navigateToPinChangeSuccess()
      setState { $0.copy(isLoading: false) }
    }
  }

  func navigateToPinChangeSuccess() {
      router.push(with: .featureCommonModule(.changePinSuccess))
  }
}
