//
//  OnboardingHomeUiModel.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 21/05/25.
//

import logic_ui
import logic_core
import logic_business
import logic_resources

public struct WelcomeViewUiModel: Equatable, Identifiable, Sendable {
    public var id: String
    public let segments: [String]
}

extension WelcomeViewUiModel {
    static func mock() -> WelcomeViewUiModel {
        WelcomeViewUiModel(id: "id",
                              segments: ["Welcome", "Consent", "Security", "Verification"])
    }
}
