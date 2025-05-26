//
//  EnrollmentView.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 22/05/25.
//

import SwiftUI
import feature_common
import logic_resources
import logic_core

struct EnrollmentView<Router: RouterHost>: View {
    @ObservedObject var viewModel: EnrollmentViewModel<Router>

    init(with viewModel: EnrollmentViewModel<Router>) {
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
private func content(state: EnrollmentViewState) -> some View {
    VStack {
        OnboardingTabsView(selectedIndex: 3)
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.shared.color.surface)
}
