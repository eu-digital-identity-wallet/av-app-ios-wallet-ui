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
import logic_core
import feature_common
import logic_resources

struct DocumentNFCView<Router: RouterHost>: View {
  @State private var viewModel: DocumentNFCViewModel<Router>

  init(with viewModel: DocumentNFCViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error
    ) {
      instructionContent(
        viewState: viewModel.viewState,
        onBackButtonTapped: viewModel.backButtonTapped,
        onNextButtonTapped: viewModel.nextButtonTapped,
        onHelpLinkTapped: viewModel.helpLinkTapped
      )
    }
    .navigationBarHidden(true)
  }
}

@MainActor
@ViewBuilder
private func instructionContent(
  viewState: DocumentNFCViewState,
  onBackButtonTapped: @escaping () -> Void,
  onNextButtonTapped: @escaping () -> Void,
  onHelpLinkTapped: @escaping () -> Void
) -> some View {
  ScrollView {
    VStack(alignment: .leading, spacing: .zero) {
      VSpacer.largeMedium()
      OnboardingTabsView(steps: PassportEnrollmentSteps.allCases,
                         selectedIndex: 1)

      VStack(alignment: .leading, spacing: .zero) {
        VSpacer.large()

        Text(LocalizableStringKey.passportBiometricsFirstHeader.toString)
          .typography(Theme.shared.font.displaySmall)
          .fontWeight(.bold)
        VSpacer.large()

        HStack {
          Spacer()
          Theme.shared.image.nfcReadingGuide
              .resizable()
              .frame(width: 260, height: 138)
          Spacer()
        }
        VSpacer.medium()

        Text(LocalizableStringKey.passportBiometricsFirstDescription.toString)
          .typography(Theme.shared.font.bodyLarge)
        VSpacer.large()

        HyperLinkView(label: LocalizableStringKey.passportBiometricsFirstLink.toString,
                      onLinkTap: {
          onHelpLinkTapped()
        })
      }
    }
    .padding(.horizontal, 16)
  }
  HStack {
    WrapButtonView(
      style: .secondary,
      title: LocalizableStringKey.genericClose,
      isLoading: false,
      onAction: onBackButtonTapped()
    )
    .padding(.horizontal, SPACING_SMALL)
    WrapButtonView(
      style: .primary,
      title: LocalizableStringKey.passportBiometricsNext,
      isLoading: false,
      onAction: onNextButtonTapped()
    )
    .padding(.horizontal, SPACING_SMALL)
  }
  .frame(maxWidth: .infinity)
  .padding(.horizontal, Theme.shared.dimension.padding)
  .padding(.bottom, 64)
}

#Preview {
  let viewState = DocumentNFCViewState(error: nil)
  instructionContent(
    viewState: viewState,
    onBackButtonTapped: {},
    onNextButtonTapped: {},
    onHelpLinkTapped: {}
  )
}
