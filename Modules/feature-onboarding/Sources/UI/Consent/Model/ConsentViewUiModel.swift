//
//  ConsentViewUiModel.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 22/05/25.
//

import logic_ui
import logic_core
import logic_business
import logic_resources

public struct ConsentViewUiModel: Equatable, Identifiable, Sendable {
    public var id: String
    public var title: String
}

extension ConsentViewUiModel {
    static func mock() -> ConsentViewUiModel {
        ConsentViewUiModel(id: "id",
                           title: "Consent screen")
    }
}
