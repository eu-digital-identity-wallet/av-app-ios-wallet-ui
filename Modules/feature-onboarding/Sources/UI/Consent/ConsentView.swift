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
            navigationTitle: .details
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
                Text(LocalizableStringKey.consentTitle.toString)
                    .font(Theme.shared.font.titleMedium.font)
                    .fontWeight(.medium)
                    .padding(.bottom, SPACING_EXTRA_LARGE)

                CheckboxView(isChecked: state.termsOfServiceAccepted, label: LocalizableStringKey.consentCheckboxLabel1.toString) { ischecked in
                    onTermsChanged(ischecked)
                }

                CheckboxView(isChecked: state.dataProtectionInfoAccepted, label: LocalizableStringKey.consentCheckboxLabel2.toString, action: { isChecked in
                    onDataProtectionChanged(isChecked)
                })

                CheckboxView(isChecked: state.dataProtectionInfoAccepted, label: LocalizableStringKey.consentCheckboxLabel3.toString, action: { isChecked in
                    onDataProcessingChanged(isChecked)
                })

                HyperLinkView(label: LocalizableStringKey.consentHyperlinkLabel1.toString, urlString: "https://www.google.com")

                HyperLinkView(label: LocalizableStringKey.consentHyperlinkLabel2.toString, urlString: "https://www.google.com")

                Spacer()
            }
        }
        .padding(.horizontal)

        Spacer()

        WrapButtonView(
            style: .primary,
            title: .consentConfirmButton,
            isLoading: false,
            isEnabled: state.nextButtonEnabled,
            onAction: onNext()
        )
        .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.shared.color.surface)
}
