//
//  OnboardingRouter.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 21/05/25.
//

import logic_ui
import logic_business
import logic_core

@MainActor
public final class OnboardingRouter {
    public static func resolve(module: FeatureOnboardingRouteModule, host: some RouterHost) -> AnyView {
        switch module {
        case .welcome:
            WelcomeView(with: .init(router: host))
                .eraseToAnyView()
        case .consent:
            ConsentView(with: .init(router: host))
                .eraseToAnyView()
        }
    }
}
