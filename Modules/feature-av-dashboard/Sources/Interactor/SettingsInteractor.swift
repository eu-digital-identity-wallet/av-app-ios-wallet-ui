//
//  SettingsInteractor.swift
//  feature-av-dashboard
//
//  Created by A200301424 on 07/07/25.
//

import logic_core
import logic_business

protocol SettingsInteractor : Sendable {
    func getAppVersion() -> String
    func deleteAgeVerificationCredentials() async -> Result<Void, Error>
}

final class SettingsInteractorImpl {
    
    private let configLogic: ConfigLogic
    private let walletController: WalletKitController
    
    init(
        configLogic: ConfigLogic,
        walletController: WalletKitController
    ) {
        self.configLogic = configLogic
        self.walletController = walletController
    }
}

extension SettingsInteractorImpl: SettingsInteractor {
    
    func getAppVersion() -> String {
        return configLogic.appVersion
    }
    
    func deleteAgeVerificationCredentials() async -> Result<Void, Error> {
      await walletController.clearAllDocuments()
      return .success(())
    }
}
