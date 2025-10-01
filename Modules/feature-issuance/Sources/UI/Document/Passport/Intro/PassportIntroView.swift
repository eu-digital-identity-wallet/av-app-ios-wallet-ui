import SwiftUI
import logic_ui
import feature_common
import logic_resources
import logic_core

struct PassportIntroView<Router: RouterHost>: View {
  @StateObject private var viewModel: PassportIntroViewModel<Router>

  init(with viewModel: PassportIntroViewModel<Router>) {
    self._viewModel = StateObject(wrappedValue: viewModel)
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
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: PassportIntroViewState,
  onBackButtonTapped: @escaping () -> Void,
  onStartProcedureTapped: @escaping () -> Void
) -> some View {
  ScrollView {
    VStack(alignment: .leading, spacing: .zero) {
      VSpacer.custom(size: 80.0)
      HStack {
        Spacer()
        Theme.shared.image.passportCard
            .resizable()
            .frame(width: 64, height: 64)
        Spacer()
      }

      VSpacer.largeMedium()
      Text(LocalizableStringKey.passpostEnrollmentHeader.toString)
        .typography(Theme.shared.font.bodyLarge)
        .foregroundStyle(Theme.shared.color.lightText)

      VSpacer.extraSmall()
      Text(LocalizableStringKey.passpostEnrollmentTitle.toString)
        .typography(Theme.shared.font.labelLarge)
        .foregroundStyle(Theme.shared.color.black)

      VSpacer.largeMedium()
      Text(LocalizableStringKey.passpostEnrollmentDescription.toString)
        .typography(Theme.shared.font.bodyLarge)
        .foregroundStyle(Theme.shared.color.black)

      VSpacer.largeMedium()
      passportEnrollmentStepsView(viewState: viewState)
    }
    .padding([.leading, .trailing], 16)
  }
  // Bottom Button Container
  VStack(spacing: 0) {
    ButtonContainer(
      secondaryTitle: LocalizableStringKey.back,
      primaryTitle: LocalizableStringKey.startProcedure,
      secondaryAction: {
        onBackButtonTapped()
      },
      primaryAction: {
        onStartProcedureTapped()
      }
    )
    .padding(.horizontal, 20)
    .padding(.vertical, 16)
    .padding(.bottom, 64)
  }
}

@MainActor
@ViewBuilder
private func passportEnrollmentStepsView(viewState: PassportIntroViewState) -> some View {
  VStack(alignment: .leading, spacing: 20.0) {
    ForEach(Array(viewState.steps.enumerated()), id: \.offset) { index, step in
      VStack(alignment: .leading, spacing: 4) {
        Text("\(index + 1). \(step.0.toString)")
          .typography(Theme.shared.font.headlineMedium)
          .foregroundColor(.primary)

        if let description = step.1 {
          Text(description.toString)
            .typography(Theme.shared.font.bodyLarge)
            .foregroundColor(Theme.shared.color.black)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.leading)
        }
      }
    }
  }
}

#Preview {
  let viewState = PassportIntroViewState(
    steps: [(LocalizableStringKey.passportEnrollmentIntroStep1Title, LocalizableStringKey.passportEnrollmentIntroStep1Description),
            (LocalizableStringKey.passportEnrollmentIntroStep2Title, LocalizableStringKey.passportEnrollmentIntroStep2Description),
            (LocalizableStringKey.passportEnrollmentIntroStep3Title, LocalizableStringKey.passportEnrollmentIntroStep3Description),
            (LocalizableStringKey.passportEnrollmentIntroStep4Title, nil),
            (LocalizableStringKey.passportEnrollmentIntroStep5Title, nil)]
  )
  content(viewState: viewState,
          onBackButtonTapped: {},
          onStartProcedureTapped: {})
}
