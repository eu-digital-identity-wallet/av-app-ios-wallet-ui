//
//  BiometrySetupViewModel.swift
//  feature-common
//
//  Created by Bharat Jagtap on 05/06/25.
//

import logic_ui
import logic_resources
import logic_authentication

@Copyable
struct BiometrySetupState: ViewState {
  let title: LocalizableStringKey
  let caption: LocalizableStringKey
  let button: LocalizableStringKey
  let skipButton: LocalizableStringKey
  let successNavigationType: UIConfig.DeepLinkNavigationType
}

final class BiometrySetupViewModel<Router: RouterHost>: ViewModel<Router, BiometrySetupState> {
  private let interactor: BiometryInteractor
  @Published var biometryError: SystemBiometryError?

  init(
    router: Router,
    interactor: BiometryInteractor,
    config: any UIConfigType
  ) {
    guard let config = config as? UIConfig.BiometricSetupUiConfig else {
      fatalError("BiometrySetupViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(title: config.title ?? .custom(""),
                          caption: config.caption,
                          button: config.button,
                          skipButton: config.skipButton,
                          successNavigationType: config.navigationSuccessType)
    )
  }

  func onOkButtonClick() {
    self.interactor.setBiometrySelection(isEnabled: true)
    interactor.authenticate()
      .sink { _ in } receiveValue: { [weak self] (state) in
        guard let self = self else { return }
        switch state {
        case .authenticated:
          self.authenticated()
        case .failure(let error):
          if error != .biometricError {
            self.biometryError = error
          }
        default: break
        }
      }.store(in: &cancellables)
  }

  func onSkipButtonClick() {
    navigateToNextScreen()
  }

  func authenticated() {
    navigateToNextScreen()
  }

  func navigateToNextScreen() {
    switch viewState.successNavigationType {
    case .pop(let screen, let inclusive):
      router.popTo(with: screen, inclusive: inclusive)
    case .deepLink(_, let popToScreen):
      router.popTo(with: popToScreen)
    case .push(let screen):
      router.push(with: screen, animated: false)
    case .none:
      break
    }
  }

  func onSettings() {
    interactor.openSettingsURL {}
  }
}
