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
            canScroll: true,
            errorConfig: viewModel.viewState.error,
            background: Theme.shared.color.surface,
            navigationTitle: .details
        ) {
            content(state: viewModel.viewState)
        }
    }
}

@MainActor
@ViewBuilder
private func content(state: ConsentViewState) -> some View {
    VStack {
        OnboardingTabsView(items: ["Welcome", "Consent", "Security", "Verification"],
                           selectedIndex: 1)
        Spacer()
        Text("Consent View")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.shared.color.surface)
}
