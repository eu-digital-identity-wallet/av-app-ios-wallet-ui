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
    @ObservedObject var viewModel: ConsentViewModel<Router>
    
    init(with viewModel: ConsentViewModel<Router>) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ContentScreenView(
            padding: .zero,
            canScroll: false,
            errorConfig: viewModel.viewState.error,
            background: Theme.shared.color.surface,
            navigationTitle: .details
        ) {
            content(state: viewModel.viewState) {
                viewModel.onNext()
            }
        }
    }
}

@MainActor
@ViewBuilder
private func content(state: ConsentViewState, onNext: @escaping () -> Void) -> some View {
    VStack {
        OnboardingTabsView(selectedIndex: 1)
        VStack(alignment: .leading) {
            Text(LocalizableStringKey.consentTitle.toString)
                .font(Theme.shared.font.titleMedium.font)
                .fontWeight(.medium)
                .padding(.bottom, SPACING_EXTRA_LARGE)
            
            CheckboxView(isChecked: state.checkbox1Checked, label: LocalizableStringKey.consentCheckboxLabel1.toString)
            
            CheckboxView(isChecked: state.checkbox1Checked, label: LocalizableStringKey.consentCheckboxLabel2.toString)

            HyperLinkView(label: LocalizableStringKey.consentHyperlinkLabel1.toString, onLinkTap: {
                debugPrint("Terms of Service tapped")
            })
            HyperLinkView(label: LocalizableStringKey.consentHyperlinkLabel2.toString, onLinkTap: {
                debugPrint("Data Protection Information tapped")
            })
            Spacer()
        }
        .padding()
        
        Spacer()
        
        WrapButtonView(
            style: .primary,
            title: .welcomeSkipButton,
            isLoading: false,
            isEnabled: (state.checkbox1Checked && state.checkbox2Checked) ? true : false,
            onAction: onNext()
        )
        .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.shared.color.surface)
}
