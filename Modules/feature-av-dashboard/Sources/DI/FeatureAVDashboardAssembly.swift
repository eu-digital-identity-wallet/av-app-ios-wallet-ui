// The Swift Programming Language
// https://docs.swift.org/swift-book

import Swinject
import logic_business
import logic_core

public final class FeatureAVDashboardAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(LandingPageInteractor.self) { r in
          LandingPageInteractorImpl(
            walletController: r.force(WalletKitController.self)
          )
        }
        .inObjectScope(ObjectScope.transient)
    }
}
