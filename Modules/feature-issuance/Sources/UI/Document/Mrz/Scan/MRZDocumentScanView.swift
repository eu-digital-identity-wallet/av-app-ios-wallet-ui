import SwiftUI
import logic_ui
import logic_resources
import mrz_reader

struct MRZDocumentScanView<Router: RouterHost>: View {
  @StateObject private var viewModel: MRZDocumentScanViewModel<Router>

  #if DEBUG
  private let loggingEnabled = true
  #else
  private let loggingEnabled = false
  #endif

  init(with viewModel: MRZDocumentScanViewModel<Router>) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    ZStack {
      DocumentScannerView(
        configuration: MRZReaderConfiguration(
          loggingEnabled: loggingEnabled,
          strings: .init(
            documentReady: LocalizableStringKey.mrzDocumentReady.toString,
            scanning: LocalizableStringKey.mrzScanning.toString,
            placeDocumentInFrame: LocalizableStringKey.mrzPlaceDocumentInFrame.toString,
            cameraError: LocalizableStringKey.mrzCameraError.toString,
            cameraPermissionDenied: LocalizableStringKey.mrzCameraPermissionDenied.toString,
            cameraSetupFailed: LocalizableStringKey.mrzCameraSetupFailed.toString,
            unknownError: LocalizableStringKey.mrzUnknownError.toString,
            initializingCamera: LocalizableStringKey.mrzInitializingCamera.toString
          )
        ),
        onMRZCaptured: { mrzData in
          viewModel.onMRZScanned(mrzData: mrzData)
        }
      )
      .ignoresSafeArea()

      // Processing overlay
      if viewModel.viewState.isProcessing {
        Color.black.opacity(0.5)
          .ignoresSafeArea()
        VStack(spacing: 16) {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(1.5)
          Text(LocalizableStringKey.processingDocument.toString)
            .foregroundColor(.white)
            .font(.headline)
        }
      }
    }
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button(action: {
          viewModel.backButtonTapped()
        }) {
          Image(systemName: "chevron.left")
            .foregroundColor(.white)
        }
      }
    }
  }
}
