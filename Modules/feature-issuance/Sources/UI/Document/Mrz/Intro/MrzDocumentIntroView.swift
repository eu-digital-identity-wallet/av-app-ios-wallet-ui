import SwiftUI
import logic_ui
import feature_common
import logic_resources
import logic_core

struct MrzDocumentIntroView<Router: RouterHost>: View {
  @State private var viewModel: MrzDocumentIntroViewModel<Router>

  init(with viewModel: MrzDocumentIntroViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true
    ) {
      content(viewState: viewModel.viewState,
              onBackButtonTapped: viewModel.backButtonTapped,
              onStartProcedureTapped: viewModel.startProcedureButtonTapped)
    }
    .navigationBarHidden(true)
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: MrzDocumentIntroViewState,
  onBackButtonTapped: @escaping () -> Void,
  onStartProcedureTapped: @escaping () -> Void
) -> some View {
  ScrollView {
    VStack(alignment: .leading, spacing: .zero) {
      VSpacer.largeMedium()
      HStack {
        Spacer()
        Theme.shared.image.passportCard
            .resizable()
            .frame(width: 64, height: 64)
        Spacer()
      }

      VSpacer.largeMedium()
      Text(LocalizableStringKey.passportScanIntroEnrollmentMethod.toString)
        .typography(Theme.shared.font.bodyLarge)
        .foregroundStyle(Theme.shared.color.lightText)

      VSpacer.extraSmall()
      Text(LocalizableStringKey.passportScanIntroTitle.toString)
        .typography(Theme.shared.font.labelLarge)

      VSpacer.largeMedium()
      Text(LocalizableStringKey.passportScanIntroDescription.toString)
        .typography(Theme.shared.font.bodyLarge)

      VSpacer.largeMedium()
      passportEnrollmentStepsView(viewState: viewState)
    }
    .padding(.horizontal, 16)
  }
  VSpacer.extraLarge()
  HStack {
    WrapButtonView(
      style: .secondary,
      title: LocalizableStringKey.genericClose,
      isLoading: false,
      onAction: onBackButtonTapped()
    )
    WrapButtonView(
      style: .primary,
      title: LocalizableStringKey.passportScanIntroStartButton,
      isLoading: false,
      onAction: onStartProcedureTapped()
    )
  }
  .frame(maxWidth: .infinity)
  .padding(.horizontal, Theme.shared.dimension.padding)
  .padding(.bottom, 64)

}

@MainActor
@ViewBuilder
private func passportEnrollmentStepsView(viewState: MrzDocumentIntroViewState) -> some View {
  VStack(alignment: .leading, spacing: 20.0) {
    ForEach(Array(viewState.steps.enumerated()), id: \.offset) { index, step in
      VStack(alignment: .leading, spacing: 4) {
        Text("\(index + 1). \(step.0.toString)")
          .typography(Theme.shared.font.headlineMedium)

        if let description = step.1 {
          Text(description.toString)
            .typography(Theme.shared.font.bodyLarge)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.leading)
        }
      }
    }
  }
}

#Preview {
  let viewState = MrzDocumentIntroViewState(
    steps: [
      (LocalizableStringKey.passportScanIntroStep1Title, LocalizableStringKey.passportScanIntroStep1Description),
      (LocalizableStringKey.passportScanIntroStep2Title, LocalizableStringKey.passportScanIntroStep2Description),
      (LocalizableStringKey.passportScanIntroStep3Title, LocalizableStringKey.passportScanIntroStep3Description),
      (LocalizableStringKey.passportScanIntroStep4Title, nil),
      (LocalizableStringKey.passportScanIntroStep5Title, nil)
    ],
    config: DocumentEnrollmentUiConfig()
  )
  content(
    viewState: viewState,
    onBackButtonTapped: {},
    onStartProcedureTapped: {}
  )
}
