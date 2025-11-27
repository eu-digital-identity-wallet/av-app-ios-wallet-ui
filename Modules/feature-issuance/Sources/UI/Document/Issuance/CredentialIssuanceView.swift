/*
 * Copyright (c) 2025 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */

import SwiftUI
import logic_ui
import feature_common
import logic_resources

struct CredentialIssuanceView<Router: RouterHost>: View {
  @State private var viewModel: CredentialIssuanceViewModel<Router>

  init(with viewModel: CredentialIssuanceViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: false,
      isLoading: viewModel.viewState.isLoading
    ) {
      content(viewState: viewModel.viewState)
    }
    .navigationBarHidden(true)
    .task {
      await viewModel.issueCredential()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: CredentialIssuanceViewState
) -> some View {
  VStack(spacing: .zero) {
    VSpacer.large()

    VStack(alignment: .leading, spacing: 24) {
      Text(LocalizableStringKey.credentialIssuanceTitle.toString)
        .typography(Theme.shared.font.headlineLarge)
        .fontWeight(.bold)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)

      Text(LocalizableStringKey.credentialIssuanceDescription.toString)
        .typography(Theme.shared.font.bodyMedium)
        .foregroundColor(Color(.secondaryLabel))
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.horizontal, Theme.shared.dimension.padding)

    Spacer()

    // Loading indicator centered
    if viewState.isLoading {
      ProgressView()
        .scaleEffect(1.5)
        .tint(Theme.shared.color.primary)
    }

    Spacer()
  }
}

#Preview {
  let viewState = CredentialIssuanceViewState(
    isLoading: true,
    error: nil
  )
  content(viewState: viewState)
}
