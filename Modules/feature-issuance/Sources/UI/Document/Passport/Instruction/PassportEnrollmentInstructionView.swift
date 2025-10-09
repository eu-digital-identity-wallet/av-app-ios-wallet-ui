import Foundation
import logic_ui
import logic_resources
import feature_common

struct PassportEnrollmentInstructionView<Router: RouterHost>: View {
  @StateObject private var viewModel: PassportEnrollmentInstructionViewModel<Router>

  init(with viewModel: PassportEnrollmentInstructionViewModel<Router>) {
    self._viewModel = StateObject(wrappedValue: viewModel)
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
    }
}

@MainActor
@ViewBuilder
private func content(
  viewState: PassportEnrollmentInstructionViewState,
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
  let viewState = PassportEnrollmentInstructionViewState(instructionPoints: [])
  content(viewState: viewState,
          onBackButtonTapped: {},
          onTakeAPhotoTapped: {})
}

@MainActor
@ViewBuilder
private func pointsSection(viewState: PassportEnrollmentInstructionViewState) -> some View {
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
