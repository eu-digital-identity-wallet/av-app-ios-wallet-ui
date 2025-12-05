//
//  Onboardingsteps.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 28/05/25.
//

import SwiftUI
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
                Text(steps[index].localizedKey.toString)
                    .font(Theme.shared.font.headlineSmall.font)
                    .foregroundColor(selectedIndex == index ? Theme.shared.color.blue : Theme.shared.color.darkGrey)
                    .padding(.all, SPACING_SMALL)
            }
        }
        .frame(maxWidth: .infinity)
        .background(content: {
            RoundedRectangle(cornerRadius: SPACING_MEDIUM_SMALL)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: SPACING_MEDIUM_SMALL)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.5), radius: SPACING_MEDIUM_SMALL, x: 0, y: SPACING_MEDIUM_SMALL)
        })
        .padding()
    }
}
