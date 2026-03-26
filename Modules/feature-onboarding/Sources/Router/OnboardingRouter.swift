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
  @ViewBuilder
    public static func resolve(module: FeatureOnboardingRouteModule, host: some RouterHost) -> some View {
        switch module {
        case .welcome:
            WelcomeView(with: .init(router: host))
        case .consent:
            ConsentView(with: .init(router: host))
        case .tokenQrIntro:
            TokenQrIntroView(with: .init(router: host))
        }
    }
}
