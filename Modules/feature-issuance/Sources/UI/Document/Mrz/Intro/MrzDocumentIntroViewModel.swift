import Foundation
import UIKit
import logic_ui
import logic_resources
import feature_common

@Copyable
struct MrzDocumentIntroViewState: ViewState {
  let steps: [(LocalizableStringKey, LocalizableStringKey?)]
  let config: DocumentEnrollmentUiConfig
  let downloadProgress: Int
  let isDownloading: Bool
  let downloadComplete: Bool
  let downloadFailed: Bool
}

@MainActor
final class MrzDocumentIntroViewModel<Router: RouterHost>: ViewModel<Router, MrzDocumentIntroViewState> {

  private let interactor: LivenessCheckInteractor
  @ObservationIgnored
  private var downloadTask: Task<Void, Never>?

  init(
    router: Router,
    interactor: LivenessCheckInteractor,
    config: DocumentEnrollmentUiConfig
  ) {
    self.interactor = interactor
    super.init(router: router,
               initialState: .init(
                steps: [(LocalizableStringKey.passportScanIntroStep1Title, LocalizableStringKey.passportScanIntroStep1Description),
                                   (LocalizableStringKey.passportScanIntroStep2Title, LocalizableStringKey.passportScanIntroStep2Description),
                                   (LocalizableStringKey.passportScanIntroStep3Title, LocalizableStringKey.passportScanIntroStep3Description),
                                   (LocalizableStringKey.passportScanIntroStep4Title, nil),
                                   (LocalizableStringKey.passportScanIntroStep5Title, nil)],
                config: config,
                downloadProgress: 0,
                isDownloading: false,
                downloadComplete: false,
                downloadFailed: false
                                  )
    )
  }

  func backButtonTapped() {
    router.pop()
  }

  func startProcedureButtonTapped() {
    // Clean up any existing passport photo from a previous flow
    LivenessCheckInteractorImpl.cleanupPassportPhoto()
    router.push(with: .featureIssuanceModule(.documentMRZInstruction(config: viewState.config)))
  }

  /// Begins the (simulated) download of verification assets, announcing progress to VoiceOver.
  /// Idempotent: subsequent calls are no-ops once the download has started or completed.
  func startAssetDownload() {
    if viewState.downloadComplete || viewState.isDownloading { return }

    downloadTask?.cancel()
    downloadTask = Task { [weak self] in
      guard let self else { return }
      await self.runAssetDownload()
    }
  }

  /// Cancels any in-flight download task when the view model goes away.
  deinit {
    downloadTask?.cancel()
  }

  @MainActor
  private func runAssetDownload() async {
    setState {
      $0.copy(downloadProgress: 0, isDownloading: true)
    }

    // Give VoiceOver time to finish reading the screen's static content
    // before posting the start announcement; otherwise iOS drops it.
    try? await Task.sleep(nanoseconds: 1_500_000_000)  // 1.5 s
    if Task.isCancelled { return }
    announceStart()

    // Run the real SDK initialization concurrently with the simulated progress bar.
    let initTask = Task { [interactor] in
      await interactor.prepareAssets()
    }

    // Throttled 0 -> 95% loop. The progress bar is visible to sighted users;
    // VoiceOver only hears the start and completion announcements to avoid
    // interrupting speech with a new message every 10%.
    for progress in stride(from: 10, through: 95, by: 10) {
      if Task.isCancelled { return }
      try? await Task.sleep(nanoseconds: 200_000_000)  // 200 ms per step
      if Task.isCancelled { return }
      setState { $0.copy(downloadProgress: progress) }
    }

    // Wait for the real init to finish before jumping to 100%.
    let ok = (try? await initTask.value) ?? false

    if Task.isCancelled { return }

    setState {
      $0.copy(
        downloadProgress: ok ? 100 : $0.downloadProgress,
        isDownloading: false,
        downloadComplete: ok,
        downloadFailed: !ok
      )
    }
    if ok {
      announceCompletion()
    } else {
      announceFailure()
    }
  }

  private func announceStart() {
    guard UIAccessibility.isVoiceOverRunning else { return }
    UIAccessibility.post(notification: .announcement, argument: LocalizableStringKey.passportScanIntroDownloadingAssets.toString)
  }

  private func announceCompletion() {
    guard UIAccessibility.isVoiceOverRunning else { return }
    UIAccessibility.post(notification: .announcement, argument: LocalizableStringKey.passportScanIntroAssetsReady.toString)
  }

  private func announceFailure() {
    guard UIAccessibility.isVoiceOverRunning else { return }
    UIAccessibility.post(notification: .announcement, argument: LocalizableStringKey.genericErrorDescription.toString)
  }
}
