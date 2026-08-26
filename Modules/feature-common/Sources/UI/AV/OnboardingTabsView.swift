//
//  Onboardingsteps.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 28/05/25.
//

import SwiftUI
import logic_ui
import logic_resources
import logic_core

public protocol Steps {
  var localizedKey: LocalizableStringKey { get }
}

public enum PassportEnrollmentSteps: Steps, Equatable, CaseIterable {
  case identification
  case biometrics
  case liveVideo

  public var localizedKey: LocalizableStringKey {
    switch self {
    case .identification:
      return LocalizableStringKey.passportIdentification
    case .biometrics:
      return LocalizableStringKey.passportBiometrics
    case .liveVideo:
      return LocalizableStringKey.passportLiveVideo
    }
  }
}

public enum Onboardingsteps: Steps, Equatable, CaseIterable {
    case welcome
    case consent
    case pin
    case enrollment

  public var localizedKey: LocalizableStringKey {
        switch self {
        case .welcome:
            return .onboardingStep1Title
        case .consent:
            return .onboardingStep2Title
        case .pin:
            return .onboardingStep3Title
        case .enrollment:
            return .onboardingStep4Title
        }
    }
}

public struct OnboardingTabsView: View {
    let steps: [Steps]
    var selectedIndex: Int = 0

  public init(steps: [Steps],
              selectedIndex: Int = 0) {
    self.selectedIndex = selectedIndex
    self.steps = steps
    }

    public var body: some View {
        HStack {
            ForEach(steps.indices, id: \.self) { index in
                let stepName = steps[index].localizedKey.toString
                let labelKey: LocalizableStringKey = selectedIndex == index
                    ? .accessibilityOboardingStepActive
                    : .accessibilityOboardingStepInactive

                Text(stepName)
                    .font(Theme.shared.font.bodySmall.font)
                    .fontWeight(.semibold)
                    .foregroundColor(selectedIndex == index ? Theme.shared.color.blue : Theme.shared.color.grey)
                    .padding(.vertical, SPACING_SMALL)
                    .padding(.horizontal, SPACING_EXTRA_SMALL)
                    .accessibilityHint(labelKey.toString)
            }
        }
        .frame(maxWidth: .infinity)
        .background(content: {
            RoundedRectangle(cornerRadius: SPACING_MEDIUM_SMALL)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: SPACING_EXTRA_SMALL, x: 0, y: SPACING_EXTRA_SMALL)
        })
        .padding()
        .accessibilityAnnouncement(
            for: selectedIndex,
            message: activeStepMessage
        )
    }

    private var activeStepMessage: String? {
        guard !steps.isEmpty, (0..<steps.count).contains(selectedIndex) else { return nil }
        return LocalizableStringKey.accessibilityOboardingStepAnnouncement(
            selectedIndex + 1,
            steps.count,
            steps[selectedIndex].localizedKey.toString
        ).toString
    }
}
