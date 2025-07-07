// The Swift Programming Language
// https://docs.swift.org/swift-book

import Swinject
import logic_business
import logic_core

public final class FeatureAVDashboardAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(LandingInteractor.self) { r in
          LandingPageInteractorImpl(
            walletController: r.force(WalletKitController.self)
          )
        }
        .inObjectScope(ObjectScope.transient)
        
        container.register(SettingsInteractor.self) { r in
          SettingsInteractorImpl(
            configLogic: r.force(ConfigLogic.self),
            walletController: r.force(WalletKitController.self)
          )
        }
        .inObjectScope(ObjectScope.transient)
    }
}
