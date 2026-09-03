import SwiftUI
import logic_ui
import feature_common
import logic_resources
import logic_core

struct MrzDocumentIntroView<Router: RouterHost>: View {
  @State private var viewModel: MrzDocumentIntroViewModel<Router>
  @AccessibilityFocusState private var startButtonFocused: Bool

  init(with viewModel: MrzDocumentIntroViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true
    ) {
      content(
        viewState: viewModel.viewState,
        startButtonFocused: $startButtonFocused,
        onBackButtonTapped: viewModel.backButtonTapped,
        onStartProcedureTapped: viewModel.startProcedureButtonTapped
      )
    }
    .navigationBarHidden(true)
    .task {
      viewModel.startAssetDownload()
    }
    .onChange(of: viewModel.viewState.downloadComplete) { _, isComplete in
      if isComplete {
        // Move VoiceOver focus to the Start button once the download completes.
        startButtonFocused = true
      }
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: MrzDocumentIntroViewState,
  startButtonFocused: AccessibilityFocusState<Bool>.Binding,
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
        .fixedSize(horizontal: false, vertical: true)

      VSpacer.largeMedium()
      passportEnrollmentStepsView(viewState: viewState)

      // Download progress section (visible while downloading or on failure).
      if viewState.isDownloading || viewState.downloadFailed {
        VSpacer.largeMedium()
        downloadProgressView(viewState: viewState)
      }
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
    .padding(.horizontal, 4)

    WrapButtonView(
      style: .primary,
      title: LocalizableStringKey.passportScanIntroStartButton,
      isLoading: viewState.isDownloading,
      isEnabled: !viewState.isDownloading && !viewState.downloadFailed,
      onAction: onStartProcedureTapped()
    )
    .padding(.horizontal, 4)
    .accessibilityIdentifier("passport_scan_intro_start_button")
    .accessibilityFocused(startButtonFocused)
  }
  .frame(maxWidth: .infinity)
  .padding(.horizontal, Theme.shared.dimension.padding)
  .padding(.bottom, 64)

}

@MainActor
@ViewBuilder
private func downloadProgressView(viewState: MrzDocumentIntroViewState) -> some View {
  VStack(alignment: .leading, spacing: 8) {
    Text(LocalizableStringKey.passportScanIntroDataDownloadNotice.toString)
      .typography(Theme.shared.font.bodyMedium)
      .fixedSize(horizontal: false, vertical: true)
      .multilineTextAlignment(.leading)

    if viewState.isDownloading {
      ProgressView(value: Double(viewState.downloadProgress), total: 100)
        .progressViewStyle(.linear)
        .accessibilityLabel(LocalizableStringKey.passportScanIntroDataDownloadNotice.toString)
        .accessibilityValue(
          LocalizableStringKey.passportLiveVideoDownloadingProgress(viewState.downloadProgress, "").toString
        )
    }

    if viewState.downloadFailed {
      Text(LocalizableStringKey.genericErrorDescription.toString)
        .typography(Theme.shared.font.bodySmall)
        .foregroundColor(Theme.shared.color.error)
    }
  }
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
  PreviewWrapper()
}

private struct PreviewWrapper: View {
  @AccessibilityFocusState private var startButtonFocused: Bool

  var body: some View {
    let viewState = MrzDocumentIntroViewState(
      steps: [
        (LocalizableStringKey.passportScanIntroStep1Title, LocalizableStringKey.passportScanIntroStep1Description),
        (LocalizableStringKey.passportScanIntroStep2Title, LocalizableStringKey.passportScanIntroStep2Description),
        (LocalizableStringKey.passportScanIntroStep3Title, LocalizableStringKey.passportScanIntroStep3Description),
        (LocalizableStringKey.passportScanIntroStep4Title, nil),
        (LocalizableStringKey.passportScanIntroStep5Title, nil)
      ],
      config: DocumentEnrollmentUiConfig(),
      downloadProgress: 0,
      isDownloading: false,
      downloadComplete: false,
      downloadFailed: false
    )
    return content(
      viewState: viewState,
      startButtonFocused: $startButtonFocused,
      onBackButtonTapped: {},
      onStartProcedureTapped: {}
    )
  }
}
