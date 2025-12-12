//
//  ConsentView.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 22/05/25.
//

import SwiftUI
import feature_common
import logic_resources
import logic_core

struct ConsentView<Router: RouterHost>: View {
    @State var viewModel: ConsentViewModel<Router>

    init(with viewModel: ConsentViewModel<Router>) {
      self._viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ContentScreenView(
            padding: .zero,
            canScroll: false,
            errorConfig: viewModel.viewState.error,
            background: Theme.shared.color.surface,
            navigationTitle: .onboardingStep2Title
        ) {
            content(state: viewModel.viewState,
                    onNext: viewModel.onNext,
                    onTermsChanged: viewModel.onTermsOfServiceChanged(ischecked:),
                    onDataProtectionChanged: viewModel.onDataProtectionInfoChanged(isChecked:),
                    onDataProcessingChanged: viewModel.onDataProcessingInfoChanged(isChecked:)
            )
        }
    }
}

@MainActor
@ViewBuilder
private func content(state: ConsentViewState, onNext: @escaping () -> Void, onTermsChanged: @escaping (Bool) -> Void, onDataProtectionChanged: @escaping (Bool) -> Void, onDataProcessingChanged: @escaping (Bool) -> Void) -> some View {
    VStack {
      OnboardingTabsView(steps: Onboardingsteps.allCases,
                         selectedIndex: 1)
        ScrollView {
            VStack(alignment: .leading) {
                Text(LocalizableStringKey.consentScreenTitle.toString)
                    .font(Theme.shared.font.titleMedium.font)
                    .fontWeight(.medium)
                    .padding(.bottom, SPACING_EXTRA_LARGE)

                CheckboxView(isChecked: state.termsOfServiceAccepted, label: LocalizableStringKey.consentScreenTosCheckbox.toString) { ischecked in
                    onTermsChanged(ischecked)
                }

                CheckboxView(isChecked: state.dataProtectionInfoAccepted, label: LocalizableStringKey.consentScreenDataProtectionCheckbox.toString, action: { isChecked in
                    onDataProtectionChanged(isChecked)
                })

                CheckboxView(isChecked: state.dataProtectionInfoAccepted, label: LocalizableStringKey.consentScreenDataProtectionCheckbox.toString, action: { isChecked in
                    onDataProcessingChanged(isChecked)
                })

                HyperLinkView(label: LocalizableStringKey.consentScreenTosButton.toString, urlString: "https://www.google.com")

                HyperLinkView(label: LocalizableStringKey.consentScreenDataProtectionButton.toString, urlString: "https://www.google.com")

                Spacer()
            }
        }
        .padding(.horizontal)

        Spacer()

        WrapButtonView(
            style: .primary,
            title: .consentScreenConfirmButton,
            isLoading: false,
            isEnabled: state.nextButtonEnabled,
            onAction: onNext()
        )
        .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.shared.color.surface)
}
