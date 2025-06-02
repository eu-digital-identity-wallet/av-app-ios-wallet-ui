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
    public static func resolve(module: FeatureAVDashboardRouteModule, host: some RouterHost) -> AnyView {
        switch module {
        case .appLanding:
            AppLandingView(with: .init(router: host))
                .eraseToAnyView()
        }
    }
}
