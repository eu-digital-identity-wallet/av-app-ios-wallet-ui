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

struct LivenessCheckView<Router: RouterHost>: View {
  @State private var viewModel: LivenessCheckViewModel<Router>

  init(with viewModel: LivenessCheckViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ZStack {
      ContentScreenView(
        padding: .zero,
        canScroll: true,
        errorConfig: viewModel.viewState.errorConfig
      ) {
        content(
          viewState: viewModel.viewState,
          onBackButtonTapped: viewModel.backButtonTapped,
          onStartVerificationTapped: viewModel.startVerificationTapped
        )
      }
      .navigationBarHidden(true)

      // Success checkmark overlay
      if viewModel.viewState.showSuccess {
        Color.black.opacity(0.4)
          .ignoresSafeArea()

        VStack {
          Image(systemName: "checkmark.circle.fill")
            .resizable()
            .frame(width: 80, height: 80)
            .foregroundColor(.green)
            .transition(.scale.combined(with: .opacity))
        }
      }
    }
    .animation(.easeInOut(duration: 0.3), value: viewModel.viewState.showSuccess)
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: LivenessCheckViewState,
  onBackButtonTapped: @escaping () -> Void,
  onStartVerificationTapped: @escaping () -> Void
) -> some View {
  ScrollView {
    VStack(alignment: .leading, spacing: .zero) {
      VSpacer.largeMedium()
      VStack(alignment: .leading, spacing: .zero) {
        VSpacer.large()

        Text(LocalizableStringKey.passportLiveVideoHeader.toString)
          .typography(Theme.shared.font.displaySmall)
          .fontWeight(.semibold)

        VSpacer.large()

        Text(LocalizableStringKey.passportLiveVideoDescription.toString)
          .typography(Theme.shared.font.bodyLarge)
          .multilineTextAlignment(.leading)

        VSpacer.large()

        // Instruction Points
        VStack(alignment: .leading, spacing: 16) {
          ForEach(Array(viewState.instructionPoints.enumerated()), id: \.offset) { _, point in
            HStack(alignment: .top, spacing: 12) {
                Text("•")
                  .typography(Theme.shared.font.bodyLarge)
                  .multilineTextAlignment(.leading)

              Text(point)
                .typography(Theme.shared.font.bodyMedium)
                .fixedSize(horizontal: false, vertical: true)
            }
          }
        }

        VSpacer.large()

        Text(LocalizableStringKey.passportLiveVideoFooter.toString)
          .typography(Theme.shared.font.bodyMedium)
          .multilineTextAlignment(.leading)

        VSpacer.extraLarge()
      }
      .padding(.horizontal, 16)
    }
  }

  HStack {
    WrapButtonView(
      style: .secondary,
      title: LocalizableStringKey.genericBack,
      gravity: .none,
      isLoading: false,
      onAction: onBackButtonTapped()
    )
    .padding(.horizontal, 4)

    WrapButtonView(
      style: .primary,
      title: LocalizableStringKey.passportLiveVideoLiveCapture,
      isLoading: viewState.isProcessing,
      onAction: onStartVerificationTapped()
    )
    .padding(.horizontal, 4)
  }
  .frame(maxWidth: .infinity)
  .padding(.horizontal, Theme.shared.dimension.padding)
  .padding(.bottom, 64)
}

#Preview {
  let viewState = LivenessCheckViewState(
    instructionPoints: [
      "Face the camera directly in good lighting.",
      "Avoid filters, masks, or obstructions."
    ],
    showSuccess: true,
    errorConfig: nil,
    isProcessing: false,
    config: DocumentEnrollmentUiConfig()
  )
  content(
    viewState: viewState,
    onBackButtonTapped: {},
    onStartVerificationTapped: {}
  )
}
