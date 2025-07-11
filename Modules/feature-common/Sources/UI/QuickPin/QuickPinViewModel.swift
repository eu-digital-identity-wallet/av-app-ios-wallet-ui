/*
 * Copyright (c) 2023 European Commission
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
import logic_ui
import logic_resources

enum QuickPinStep: Equatable {
  case validate
  case firstInput
  case retryInput(String)
}

@Copyable
struct QuickPinState: ViewState {
  let config: QuickPinUiConfig
  let navigationTitle: LocalizableStringKey
  let title: LocalizableStringKey
  let caption: LocalizableStringKey
  let button: LocalizableStringKey
  let success: LocalizableStringKey
  let successButton: LocalizableStringKey
  let successNavigationType: UIConfig.DeepLinkNavigationType
  let isCancellable: Bool
  let pinError: LocalizableStringKey?
  let isButtonActive: Bool
  let step: QuickPinStep
  let quickPinSize: Int
}

final class QuickPinViewModel<Router: RouterHost>: ViewModel<Router, QuickPinState> {

  @Published var uiPinInputField: String = ""
  @Published var isCancelModalShowing: Bool = false
  private let interactor: QuickPinInteractor

  init(
    router: Router,
    interactor: QuickPinInteractor,
    config: any UIConfigType
  ) {
    guard let config = config as? QuickPinUiConfig else {
      fatalError("QuickPinViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        config: config,
        navigationTitle: config.isSetFlow ? .quickPinEnterPin : .quickPinConfirmPin,
        title: config.isSetFlow ? .quickPinSetTitle : .quickPinUpdateTitle,
        caption: config.isSetFlow ? .quickPinSetCaptionOne : .quickPinUpdateCaptionOne,
        button: .quickPinNextButton,
        success: config.isSetFlow ? .quickPinSetSuccess : .quickPinUpdateSuccess,
        successButton: config.isSetFlow ? .quickPinSetSuccessButton : .quickPinUpdateSuccessButton,
        successNavigationType: config.isSetFlow
        ? .push(screen: .featureIssuanceModule(.issuanceAddDocument(config: IssuanceFlowUiConfig(flow: .noDocument))))
        : .pop(screen: .featureAVDashboardModule(.appLanding)),
        isCancellable: config.isUpdateFlow,
        pinError: nil,
        isButtonActive: false,
        step: config.isSetFlow ? .firstInput : .validate,
        quickPinSize: 6
      )
    )

    self.subscribeToPinInput()
  }

  func onButtonClick() {
    switch viewState.step {
    case .validate:
      onValidate()
    case .firstInput:
      setState {
        $0
          .copy(
            navigationTitle: .quickPinConfirmPin,
            caption: viewState.config.isSetFlow ? .quickPinSetCaptionTwo : .quickPinUpdateCaptionThree,
            button: .quickPinConfirmButton,
            step: .retryInput(uiPinInputField)
          )
          .copy(pinError: nil)
      }
      uiPinInputField = ""
    case .retryInput(let previousPin):
      guard previousPin == uiPinInputField else {
        setState {
          $0.copy(pinError: .quickPinDoNotMatch)
        }
        return
      }
      onSuccess()
    }
  }

  func onShowCancellationModal() {
    isCancelModalShowing = !isCancelModalShowing
  }

  func onPop() {
    isCancelModalShowing = false
    router.pop()
  }

  func toolbarContent() -> ToolBarContent? {
    var leadingActions: [ToolBarContent.Action] = []
    if viewState.isCancellable {
      leadingActions.append(
        .init(
          image: Theme.shared.image.chevronLeft
        ) {
          self.onShowCancellationModal()
        })
    }

    return .init(
      trailingActions: [
        .init(
          title: viewState.button,
          disabled: !viewState.isButtonActive
        ) {
          self.onButtonClick()
        }
      ],
      leadingActions: leadingActions
    )
  }

  private func onValidate() {
    switch interactor.isPinValid(pin: uiPinInputField) {
    case .success:
      setState {
        $0
          .copy(
            caption: .quickPinUpdateCaptionTwo,
            button: .quickPinNextButton,
            step: .firstInput
          )
          .copy(pinError: nil)
      }
      uiPinInputField = ""
    case .failure(let error):
      setState {
        $0.copy(pinError: .custom(error.localizedDescription))
      }
    }
  }

  private func onSuccess() {
    interactor.setPin(newPin: uiPinInputField)

    if viewState.config.isSetFlow {
      let biometrySetupConfig = UIConfig.BiometricSetupUiConfig(
        title: .biometricSetupTitle,
        caption: .biometricSetupDescription(LocalizableStringKey.splashTitle.toString),
        button: .biometricSetupButton,
        skipButton: .biometricSetupSkipButton,
        navigationSuccessType: viewState.successNavigationType)
      router.push(with: .featureCommonModule(.biometrySetup(config: biometrySetupConfig)))
      return
    }

    switch viewState.successNavigationType {
    case .pop(let screen, let inclusive):
      router.popTo(with: screen, inclusive: inclusive)
    case .deepLink(_, let popToScreen):
      router.popTo(with: popToScreen)
    case .push(let screen):
      router.push(with: screen)
    case .none:
      break
    }
  }

  private func subscribeToPinInput() {
    $uiPinInputField
      .dropFirst()
      .removeDuplicates()
      .sink { [weak self] value in
        guard let self = self else { return }
        self.processPin(value: value)
      }.store(in: &cancellables)
  }

  private func processPin(value: String) {
    setState {
      $0
        .copy(pinError: nil)
        .copy(isButtonActive: value.count == viewState.quickPinSize)
    }

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: DispatchWorkItem(block: { [weak self] in
      guard let sSelf = self else { return }
      if value.count == sSelf.viewState.quickPinSize {
        sSelf.onButtonClick()
      }
    }))
  }
}
