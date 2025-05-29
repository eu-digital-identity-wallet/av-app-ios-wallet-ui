//
//  OboardingSteps.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 28/05/25.
//

import SwiftUI
import logic_resources
import logic_core

enum OboardingSteps: Equatable {
    case welcome
    case consent
    case pin
    case enrollment

    var localizedKey: LocalizableStringKey {
        switch self {
        case .welcome:
            return .onboardingStepWelcome
        case .consent:
            return .onboardingStepConsent
        case .pin:
            return .onboardoingStepPin
        case .enrollment:
            return .onboardingStepEnrollment
        }
    }
}

public struct OnboardingTabsView: View {
    let steps: [OboardingSteps] = [.welcome, .consent, .pin, .enrollment]
    var selectedIndex: Int = 0

    public init(selectedIndex: Int = 0) {
        self.selectedIndex = selectedIndex
    }

    public var body: some View {
        HStack {
            ForEach(steps.indices, id: \.self) { index in
                Text(steps[index].localizedKey.toString)
                    .font(Theme.shared.font.headlineSmall.font)
                    .foregroundColor(selectedIndex == index ? Theme.shared.color.blue : Theme.shared.color.darkGrey)
                    .padding(.all, SPACING_SMALL)
            }
        }
        .background(content: {
            RoundedRectangle(cornerRadius: SPACING_MEDIUM_SMALL)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: SPACING_MEDIUM_SMALL)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.5), radius: SPACING_MEDIUM_SMALL, x: 0, y: SPACING_MEDIUM_SMALL)
        })
    }
}
