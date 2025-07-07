//
//  BiometrySetupView.swift
//  feature-common
//
//  Created by Bharat Jagtap on 05/06/25.
//

import SwiftUI
import logic_ui
import logic_resources

struct BiometrySetupView<Router: RouterHost>: View {
  @ObservedObject var viewModel: BiometrySetupViewModel<Router>

  init(with viewModel: BiometrySetupViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      navigationTitle: nil,
      toolbarContent: nil
    ) {
      content(
        viewState: viewModel.viewState,
        onOkButtonClick: { viewModel.onOkButtonClick() },
        onSkipButtonClick: { viewModel.onSkipButtonClick() }
      )
    }
    .alert(item: $viewModel.biometryError) { error in
      Alert(
        title: Text(.genericErrorTitle),
        message: Text(error.errorDescription.orEmpty),
        primaryButton: .default(Text(.biometryOpenSettings)) {
          self.viewModel.onSettings()
        },
        secondaryButton: .cancel {}
      )
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: BiometrySetupState,
  onOkButtonClick: @escaping () -> Void,
  onSkipButtonClick: @escaping () -> Void
) -> some View {
  OnboardingTabsView(selectedIndex: 2)
  VStack(alignment: .leading, spacing: .zero) {
    VSpacer.small()
    Text(viewState.title)
      .typography(Theme.shared.font.titleMedium)
    VSpacer.small()
    Text(viewState.caption)
      .typography(Theme.shared.font.bodyMedium)
    Spacer()
    HStack {
      WrapButtonView(
        style: .secondary,
        title: viewState.skipButton,
        isLoading: false,
        onAction: onSkipButtonClick()
      )
      .padding(.horizontal, SPACING_SMALL)
      WrapButtonView(
        style: .primary,
        title: viewState.button,
        isLoading: false,
        onAction: onOkButtonClick()
      )
      .padding(.horizontal, SPACING_SMALL)
    }
    .frame(maxWidth: .infinity)
  }
  .frame(maxWidth: .infinity)
  .padding(.horizontal, Theme.shared.dimension.padding)
}
