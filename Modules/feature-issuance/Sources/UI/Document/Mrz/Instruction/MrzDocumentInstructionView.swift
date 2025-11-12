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

import Foundation
import logic_ui
import logic_resources
import feature_common

struct MrzDocumentInstructionView<Router: RouterHost>: View {
  @State private var viewModel: MrzDocumentInstructionViewModel<Router>

  init(with viewModel: MrzDocumentInstructionViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }
    var body: some View {
      ContentScreenView(
        padding: .zero,
        canScroll: true
      ) {
        content(viewState: viewModel.viewState,
                onBackButtonTapped: viewModel.backButtonTapped,
                onTakeAPhotoTapped: viewModel.takeAPhotoTapped)
      }
      .navigationBarHidden(true)
    }

}

@MainActor
@ViewBuilder
private func content(
  viewState: MrzDocumentInstructionViewState,
  onBackButtonTapped: @escaping () -> Void,
  onTakeAPhotoTapped: @escaping () -> Void
) -> some View {
  ScrollView {
    VStack(alignment: .leading, spacing: .zero) {

      VSpacer.largeMedium()
      OnboardingTabsView(steps: PassportEnrollmentSteps.allCases,
                         selectedIndex: 0)

      VStack(alignment: .leading, spacing: .zero) {
        VSpacer.large()

        Text(LocalizableStringKey.passportEnrollmentInstructionHeader.toString)
          .typography(Theme.shared.font.labelLarge)
        VSpacer.large()

        Text(LocalizableStringKey.passportEnrollmentInstructionBody1.toString)
          .typography(Theme.shared.font.bodyLarge)
        VSpacer.large()

        pointsSection(viewState: viewState)

        VSpacer.large()
        Text(LocalizableStringKey.passportEnrollmentInstructionBody2.toString)
          .typography(Theme.shared.font.bodyLarge)
          .multilineTextAlignment(.leading)
        Spacer()
      }
      .padding(.horizontal, 16)
    }
  }
  HStack {
    WrapButtonView(
      style: .secondary,
      title: LocalizableStringKey.back,
      isLoading: false,
      onAction: onBackButtonTapped()
    )
    .padding(.horizontal, SPACING_SMALL)
    WrapButtonView(
      style: .primary,
      title: LocalizableStringKey.takeAPhoto,
      isLoading: false,
      onAction: onTakeAPhotoTapped()
    )
    .padding(.horizontal, SPACING_SMALL)
  }
  .frame(maxWidth: .infinity)
  .padding(.horizontal, Theme.shared.dimension.padding)
  .padding(.bottom, 64)

}

#Preview {
  let viewState = MrzDocumentInstructionViewState(
    instructionPoints: [
      "Hold your passport steady",
      "Ensure good lighting"
    ],
    config: DocumentEnrollmentUiConfig()
  )
  content(
    viewState: viewState,
    onBackButtonTapped: {},
    onTakeAPhotoTapped: {}
  )
}

@MainActor
@ViewBuilder
private func pointsSection(viewState: MrzDocumentInstructionViewState) -> some View {
  VStack(alignment: .leading, spacing: .zero) {

    ForEach(viewState.instructionPoints, id: \.self) { point in
      HStack(alignment: .firstTextBaseline) {
        Text("•")
          .typography(Theme.shared.font.bodyLarge)
          .multilineTextAlignment(.leading)
        Text(point)
          .typography(Theme.shared.font.bodyLarge)
          .multilineTextAlignment(.leading)
      }
      VSpacer.small()
    }
  }
  .padding(.horizontal)
}
