//
//  TokenQrIntroView.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 26/03/26.
//

import SwiftUI
import logic_ui
import logic_resources
import feature_common

struct TokenQrIntroView<Router: RouterHost>: View {
  @State var viewModel: TokenQrIntroViewModel<Router>

  init(with viewModel: TokenQrIntroViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      navigationTitle: nil,
      toolbarContent: nil
    ) {
      content(
        viewState: viewModel.viewState,
        onScanButtonClick: { viewModel.onScan() },
        onBackButtonClick: { viewModel.onBack() }
      )
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: TokenQrIntroState,
  onScanButtonClick: @escaping () -> Void,
  onBackButtonClick: @escaping () -> Void
) -> some View {
    VStack {
      OnboardingTabsView(steps: Onboardingsteps.allCases,
                           selectedIndex: 3)
      ScrollView {
        VStack(alignment: .leading, spacing: .zero) {
          VSpacer.small()
          Theme.shared.image.scanIcon.resizable()
          .frame(width: 80, height: 80)
          .accessibilityHidden(true)
          VSpacer.large()
          Text(.onboardingTokenQrIntroTitle)
          .typography(Theme.shared.font.titleMedium)
          .fontWeight(.medium)
          .accessibilityAddTraits(.isHeader)
          VSpacer.large()
          Text(.onboardingTokenQrIntroDescription)
          .typography(Theme.shared.font.bodyMedium)
          Spacer()
        }
      }
        
     Spacer()
        
     HStack {
       WrapButtonView(
        style: .secondary,
        title: .genericBack,
        isLoading: false,
        onAction: onBackButtonClick()
       )
       .padding(.horizontal, SPACING_SMALL)
       WrapButtonView(
        style: .primary,
        title: .genericScanQr,
        isLoading: false,
        onAction: onScanButtonClick()
       )
       .padding(.horizontal, SPACING_SMALL)
     }
     .frame(maxWidth: .infinity)
     .padding(.horizontal, Theme.shared.dimension.padding)
  }
  .padding(.horizontal, Theme.shared.dimension.padding)
  .padding(.bottom)
}
  
