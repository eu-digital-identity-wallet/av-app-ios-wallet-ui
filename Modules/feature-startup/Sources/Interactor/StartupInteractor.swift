/*
 * Copyright (c) 2026 European Commission
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
import Foundation
import feature_common
import logic_core
import logic_business
import LocalAuthentication

public protocol StartupInteractor: Sendable {
  func initialize(with splashAnimationDuration: TimeInterval) async -> AppRoute
  func getAppVersion() async -> String
}

final actor StartupInteractorImpl: StartupInteractor {

  private let walletKitController: WalletKitController
  private let quickPinInteractor: QuickPinInteractor
  private let keyChainController: KeyChainController
  private let prefsController: PrefsController
  private let configLogic: ConfigLogic
  private let deviceAuthenticationAvailable: @Sendable () -> Bool

  init(
    walletKitController: WalletKitController,
    quickPinInteractor: QuickPinInteractor,
    keyChainController: KeyChainController,
    prefsController: PrefsController,
    configLogic: ConfigLogic,
    deviceAuthenticationAvailable: @Sendable @escaping () -> Bool
  ) {
    self.walletKitController = walletKitController
    self.quickPinInteractor = quickPinInteractor
    self.keyChainController = keyChainController
    self.prefsController = prefsController
    self.configLogic = configLogic
    self.deviceAuthenticationAvailable = deviceAuthenticationAvailable
  }

  public func initialize(with splashAnimationDuration: TimeInterval) async -> AppRoute {
    guard deviceAuthenticationAvailable() else {
      return .featureStartupModule(.unsupportedDevice)
    }
    await manageStorageForFirstRun()
    await clearStorageIfPinRemoved()
    try? await walletKitController.loadDocuments()
    let hasDocuments = await !walletKitController.fetchAllDocuments().isEmpty
    try? await Task.sleep(nanoseconds: splashAnimationDuration.nanoseconds)
    if await quickPinInteractor.hasPin() {
      return .featureCommonModule(
        .biometry(
          config: UIConfig.Biometry(
            navigationTitle: .custom(""),
            title: .biometricLoginTitle,
            caption: .biometricLoginBiometricsEnabledSubtitle,
            quickPinOnlyCaption: .biometricLoginBiometricsNotEnabledSubtitle,
            navigationSuccessType: .push(
              hasDocuments
              ? .featureAVDashboardModule(.appLanding)
              : .featureIssuanceModule(.issuanceAddDocument(config: IssuanceFlowUiConfig(flow: .noDocument)))
            ),
            navigationBackType: nil,
            isPreAuthorization: true,
            shouldInitializeBiometricOnCreate: true
          )
        )
      )
    } else {
        return .featureOnboardingModule(.welcome)
    }
  }

  func getAppVersion() async -> String {
    configLogic.appVersion
  }

  private func manageStorageForFirstRun() async {
    if !prefsController.getBool(forKey: .runAtLeastOnce) {
      try? await walletKitController.clearAllDocuments()
      keyChainController.clear()
      prefsController.setValue(true, forKey: .runAtLeastOnce)
    }
  }

  private func clearStorageIfPinRemoved() async {
    let hasPin = await quickPinInteractor.hasPin()
    guard !hasPin else { return }

    try? await walletKitController.loadDocuments()
    let hasDocuments = await !walletKitController.fetchAllDocuments().isEmpty
    guard hasDocuments else { return }

    try? await walletKitController.clearAllDocuments()
    keyChainController.clear()
    prefsController.remove(forKey: .lastUsedPinHashes)
    prefsController.remove(forKey: .cachedDeepLink)
    prefsController.remove(forKey: .biometryEnabled)
    prefsController.remove(forKey: .batchCounter)
  }
}

extension StartupInteractorImpl {
  static let defaultDeviceAuthenticationAvailable: @Sendable () -> Bool = {
    var error: NSError?
    return LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
  }
}
