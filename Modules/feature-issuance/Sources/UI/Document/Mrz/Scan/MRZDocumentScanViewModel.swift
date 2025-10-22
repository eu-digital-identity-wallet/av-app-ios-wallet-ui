import Foundation
import logic_ui
import logic_resources
import feature_common
import mrz_reader

@Copyable
struct MRZDocumentScanViewState: ViewState {
  let isProcessing: Bool
  let error: ContentErrorView.Config?
}

final class MRZDocumentScanViewModel<Router: RouterHost>: ViewModel<Router, MRZDocumentScanViewState> {

  private let interactor: MRZDocumentScanInteractor

  init(
    router: Router,
    interactor: MRZDocumentScanInteractor
  ) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        isProcessing: false,
        error: nil
      )
    )
  }

  func backButtonTapped() {
    router.pop()
  }

  func onMRZScanned(mrzData: MRZData) {
    // Prevent multiple scans while processing
    guard !viewState.isProcessing else { return }

    setState { $0.copy(isProcessing: true) }

    Task {
      let result = await Task.detached { () -> MRZProcessingPartialState in
        return await self.interactor.processMRZData(mrzData: mrzData)
      }.value

      switch result {
      case .success(let documentId):
        // TODO: Navigate to success screen with document details
        // For now, just pop back with success
        setState {
          $0.copy(isProcessing: false, error: nil)
        }
        // Navigate to success or back to previous screen
        router.pop()

      case .failure(let error):
        setState {
          $0.copy(
            isProcessing: false,
            error: .init(
              description: .custom(error.localizedDescription),
              cancelAction: { [weak self] in
                self?.onErrorDismissed()
              }()
            )
          )
        }
      }
    }
  }

  func onErrorDismissed() {
    setState {
      $0.copy(error: nil)
    }
  }
}
