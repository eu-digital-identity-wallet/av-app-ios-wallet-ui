/*
 * Copyright (c) 2025 European Commission
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
import logic_authentication
import Observation

@Copyable
public struct BiometryState: ViewState {
  let config: UIConfig.Biometry
  let areBiometricsEnabled: Bool
  let pinError: String?
  let throttlePinInput: Bool
  let scenePhase: ScenePhase
  let pendingNavigation: UIConfig.ThreeWayNavigationType?
  let autoBiometryInitiated: Bool
  let biometryImage: Image?
  let isCancellable: Bool
  let quickPinSize: Int
  let lockoutEndTime: TimeInterval
  let contentHeaderConfig: ContentHeaderConfig
  let isLockoutStatusChecked: Bool
  var isLockedOut: Bool {
    !isLockoutStatusChecked || lockoutEndTime > 0
  }
}

@Observable
final public class BiometryViewModel<Router: RouterHost>: ViewModel<Router, BiometryState> {

  @ObservationIgnored
  private let AUTO_VERIFY_ON_APPEAR_DELAY = 250
  @ObservationIgnored
  private let PIN_INPUT_DEBOUNCE = 250
  private var lockoutTimer: LockoutTimer

  var uiPinInputField: String = "" {
    didSet {
      debouncedPinInputField.send(uiPinInputField)
    }
  }
  var biometryError: SystemBiometryError?

  @ObservationIgnored
  private let interactor: BiometryInteractor

  @ObservationIgnored
  private var debouncedPinInputField = CurrentValueSubject<String, Never>("")

  public init(
    router: Router,
    interactor: BiometryInteractor,
    config: any UIConfigType,
    throttlePinInput: Bool = true
  ) {
    guard let config = config as? UIConfig.Biometry else {
      fatalError("BiometryViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    self.lockoutTimer = LockoutTimer()

    super.init(
      router: router,
      initialState: .init(
        config: config,
        areBiometricsEnabled: false,
        pinError: nil,
        throttlePinInput: throttlePinInput,
        scenePhase: .active,
        pendingNavigation: nil,
        autoBiometryInitiated: false,
        biometryImage: nil,
        isCancellable: config.navigationBackType != nil,
        quickPinSize: 6,
        lockoutEndTime: 0,
        contentHeaderConfig: .init(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
            appText: ThemeManager.shared.image.euditext
          )
        ),
        isLockoutStatusChecked: false
      )
    )

    self.subscribeToPinInput()
  }

  func onAppearBiometry() async {

    let biometricsImage = await interactor.getBiometricsImage()
    let isBiometryEnabled = await interactor.isBiometryEnabled()

    setState {
      $0.copy(
        areBiometricsEnabled: isBiometryEnabled,
        biometryImage: biometricsImage
      )
    }

    await checkCurrentLockoutStatus()
    setState { $0.copy(isLockoutStatusChecked: true) }
    guard !viewState.isLockedOut else {
      return
    }

    if viewState.config.shouldInitializeBiometricOnCreate, viewState.areBiometricsEnabled, !viewState.autoBiometryInitiated {
      setState { $0.copy(autoBiometryInitiated: true) }
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(AUTO_VERIFY_ON_APPEAR_DELAY)) {
        self.onBiometry()
      }
    }
  }

  func onPop() {
    if let backNavigation = viewState.config.navigationBackType {
      doNavigation(navigationType: backNavigation)
    }
  }

  func onBiometry() {
    guard !viewState.isLockedOut else {
      return
    }
    Task {
      switch await interactor.authenticate() {
      case .authenticated:
        self.authenticated()
      case .failure(let error):
        if error != .biometricError {
          self.biometryError = error
        }
      }
    }
  }

  func onSettings() {
    Task { await interactor.openSettings {} }
  }

  func setPhase(with phase: ScenePhase) {
    setState { $0.copy(scenePhase: phase) }
    if let pending = viewState.pendingNavigation {
      doNavigation(navigationType: pending)
    }
  }

  private func checkCurrentLockoutStatus() async {
    let lockoutStatus = await interactor.getLockoutStatus()
    if lockoutStatus.isLockedOut {
      setState { $0.copy(lockoutEndTime: lockoutStatus.lockoutEndTimeInterval) }
      startLockoutTimer(lockoutEndTime: Double(lockoutStatus.lockoutEndTimeInterval!))
    }
  }

  private func subscribeToPinInput() {

    let publisher = self.debouncedPinInputField.dropFirst()

    if viewState.throttlePinInput {
      publisher
        .debounce(for: .milliseconds(PIN_INPUT_DEBOUNCE), scheduler: RunLoop.main)
        .removeDuplicates()
        .sink { [weak self] value in
          guard let self = self else { return }
          self.processPin(value: value)
        }.store(in: &cancellables)
    } else {
      publisher
        .removeDuplicates()
        .sink { [weak self] value in
          guard let self = self else { return }
          self.processPin(value: value)
        }.store(in: &cancellables)
    }
  }

  private func processPin(value: String) {
    Task {
      if value.count == viewState.quickPinSize {
        switch await interactor.isPinValid(with: uiPinInputField) {
        case .success:
          self.authenticated()
        case .failure(let error):
          setState { $0.copy(pinError: error.errorMessage) }
        case .lockedOut(lockoutEndTime: let lockoutEndTime):
          startLockoutTimer(lockoutEndTime: lockoutEndTime)
        }
      } else {
        setState { $0.copy(pinError: nil) }
      }
    }
  }

  private func startLockoutTimer(lockoutEndTime: TimeInterval) {
    setState { $0.copy(lockoutEndTime: lockoutEndTime) }
    lockoutTimer.start(until: lockoutEndTime) { message in
      _Concurrency.Task {
        await MainActor.run {
          self.setState {
            $0.copy(pinError: message)
          }
        }
      }
    } onCompletion: {
      _Concurrency.Task {
        await MainActor.run {
          self.setState {
            $0.copy(pinError: nil)
              .copy(lockoutEndTime: 0)
          }
        }
      }
    }
  }

  private func authenticated() {
    if let navigationSuccessType = viewState.config.navigationSuccessType {
      doNavigation(navigationType: navigationSuccessType)
    } else {
      viewState.config.onAuthResult?(.success)
    }
  }

  private func pinAttemptFailed(_ error: Error) {
    setState { $0.copy(pinError: error.localizedDescription) }
  }

  private func doNavigation(navigationType: UIConfig.ThreeWayNavigationType) {

    guard viewState.scenePhase == .active else {
      setState { $0.copy(pendingNavigation: navigationType) }
      return
    }

    switch navigationType {
    case .popTo(let route):
      router.popTo(with: route)
    case .push(let route):
      router.push(with: route)
    case .pop:
      router.pop()
    }
  }

  func toolbarContent() -> ToolBarContent? {
    var leadingActions: [ToolBarContent.Action] = []
    if viewState.isCancellable {
      leadingActions.append(
        .init(
          image: Theme.shared.image.chevronLeft,
          accessibilityLocator: ToolbarLocators.chevronLeft
        ) {
          self.onPop()
      })

      return .init(
        leadingActions: leadingActions
      )
    }

    return nil
  }
}
