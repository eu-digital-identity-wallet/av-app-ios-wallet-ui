//
//  EnrollmentViewUiModel.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 22/05/25.
//

import logic_ui
import logic_core
import logic_business
import logic_resources

public struct EnrollmentViewUiModel: Equatable, Identifiable, Sendable {
    public var id: String
}

extension EnrollmentViewUiModel {
    static func mock() -> EnrollmentViewUiModel {
        EnrollmentViewUiModel(id: "id")
    }
}
