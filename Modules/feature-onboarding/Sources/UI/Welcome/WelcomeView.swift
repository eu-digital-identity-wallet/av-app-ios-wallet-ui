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
    @State var viewModel: WelcomeViewModel<Router>
    init(with viewModel: WelcomeViewModel<Router>) {
      self._viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
      ContentScreenView(
        padding: .zero,
        canScroll: true,
        errorConfig: viewModel.viewState.error,
        background: Theme.shared.color.surface
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

      VStack(spacing: SPACING_SMALL) {
        ScrollView {
        OnboardingTabsView(steps: Onboardingsteps.allCases,
                           selectedIndex: 0)
        WelcomeInfoCarousel()
      }
        WrapButtonView(
          style: .primary,
          title: .welcomeScreenSkip,
          isLoading: false,
          isEnabled: true,
          onAction: onNext()
        )
        .padding(.horizontal)
        .padding(.top, SPACING_SMALL)
        .padding(.bottom, SPACING_LARGE_MEDIUM)
    }
  
}
