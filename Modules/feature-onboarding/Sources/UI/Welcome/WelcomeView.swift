//
//  OnboardingHomeView.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 21/05/25.
//

import SwiftUI
import feature_common
import logic_resources
import logic_core

struct WelcomeView<Router: RouterHost>: View {
    @ObservedObject var viewModel: WelcomeViewModel<Router>

    init(with viewModel: WelcomeViewModel<Router>) {
        self.viewModel = viewModel
    }

    var body: some View {
        ContentScreenView(
            padding: .zero,
            canScroll: true,
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
private func content(state: WelcomeViewState,
                     onNext: @escaping () -> Void) -> some View {
    VStack {
        OnboardingTabsView(items: ["Welcome", "Consent", "Security", "Verification"])
        Spacer()
        WrapButtonView(
            style: .primary,
            title: .welcomeSkipButton,
            isLoading: false,
            isEnabled: true,
            onAction: onNext()
        )
        Spacer(minLength: 30)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.shared.color.surface)
}
