import SwiftUI
import logic_ui
import logic_core
import feature_common
import logic_resources

struct DocumentNFCView<Router: RouterHost>: View {
  @StateObject private var viewModel: DocumentNFCViewModel<Router>

  init(with viewModel: DocumentNFCViewModel<Router>) {
    self._viewModel = StateObject(wrappedValue: viewModel)
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
      title: LocalizableStringKey.back,
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
