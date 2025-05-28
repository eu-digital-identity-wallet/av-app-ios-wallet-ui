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
        ZStack {
            Theme.shared.color.surface
                .ignoresSafeArea(.all)
            ContentScreenView(
                padding: .zero,
                canScroll: false,
                errorConfig: viewModel.viewState.error,
                background: Theme.shared.color.surface
            ) {
                content(state: viewModel.viewState) {
                    viewModel.onNext()
                }
            }
        }
    }
}

@MainActor
@ViewBuilder
private func content(state: WelcomeViewState,
                     onNext: @escaping () -> Void) -> some View {
    
    VStack {
        OnboardingTabsView(selectedIndex: 0)
        WelcomeInfoCarousel()
        Spacer()
        WrapButtonView(
            style: .primary,
            title: .welcomeSkipButton,
            isLoading: false,
            isEnabled: true,
            onAction: onNext()
        )
        .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)

}
