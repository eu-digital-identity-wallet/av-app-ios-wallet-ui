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

struct OnboardingHomeView<Router: RouterHost>: View {
    @ObservedObject var viewModel: OnboardingHomeViewModel<Router>

    init(with viewModel: OnboardingHomeViewModel<Router>) {
        self.viewModel = viewModel
    }

    var body: some View {
        content(state: viewModel.viewState)
    }
}

@MainActor
@ViewBuilder
private func content(state: OnboardingHomeViewState) -> some View {
    VStack {
        Text("Onboarding Home View")
    }
}
