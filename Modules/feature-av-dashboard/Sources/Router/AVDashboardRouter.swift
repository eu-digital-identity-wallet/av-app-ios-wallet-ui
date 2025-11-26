//
//  AVDashboardRouter.swift
//  feature-av-dashboard
//
//  Created by A200156428 on 30/05/25.
//

import logic_ui
import logic_business
import logic_core

@MainActor
public final class AVDashboardRouter {
  @ViewBuilder
    public static func resolve(module: FeatureAVDashboardRouteModule, host: some RouterHost) -> some View {
        switch module {
        case .appLanding:
          LandingView(with: .init(router: host, interactor: DIGraph.shared.resolver.force(
                LandingInteractor.self
            )))
        case .settings:
            SettingsView(with: .init(
                router: host,
                interactor: DIGraph.shared.resolver.force(SettingsInteractor.self)
            ))
        }
    }
}
