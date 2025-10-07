import SwiftUI
import logic_ui
import logic_resources
import logic_core
import AVFoundation

struct CameraView<Router: RouterHost>: View {
  @StateObject private var viewModel: CameraViewModel<Router>

  init(with viewModel: CameraViewModel<Router>) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
    var body: some View {
      ContentScreenView(
        padding: .zero,
        canScroll: false,
        toolbarContent: nil
      ) {
        content(viewState: viewModel.viewState,
                camera: viewModel.viewState.camera,
                onBackButtonTapped: viewModel.backButtonTapped)
      }
      .onAppear {
        viewModel.viewState.camera.checkPermissions()
      }
      .onDisappear {
        viewModel.viewState.camera.stopSession()
      }
    }
}

@MainActor
@ViewBuilder
private func content(
  viewState: CameraViewState,
  camera: CameraModel,
  onBackButtonTapped: @escaping () -> Void
) -> some View {
  ZStack(alignment: .top) {
    // Camera Preview
    CameraPreview(camera: camera)
      .ignoresSafeArea()
    VStack(spacing: .zero) {
      HStack {
        Button(
          action: {
            onBackButtonTapped()
          }
        ) {
          HStack(spacing: SPACING_SMALL) {
            Image(systemName: "arrow.left")
              .font(.title3)
            Text(LocalizableStringKey.back.toString)
              .typography(Theme.shared.font.headlineSmall)
          }
          .foregroundColor(.white)
          .padding(.bottom, SPACING_LARGE_MEDIUM)
        }
        Spacer()
      }
      .background(Theme.shared.color.black)

      Color(red: 0.267, green: 0.239, blue: 0.208)
        .frame(height: 108)

      Spacer()

      Color(red: 0.267, green: 0.239, blue: 0.208)
        .frame(height: 130)

      // Capture Button
      VStack {
        Button(
          action: {
            camera.capturePhoto()
          }
        ) {
          Circle()
            .stroke(Theme.shared.color.white,
                    lineWidth: SPACING_EXTRA_SMALL)
            .frame(width: 70, height: 70)
            .overlay(
              Circle()
                .fill(Theme.shared.color.white)
                .frame(width: 60, height: 60)
            )
        }
        .padding(.vertical, SPACING_LARGE_MEDIUM)
        Text(LocalizableStringKey.passportCaptureDescription.toString)
          .typography(Theme.shared.font.bodySmall)
          .foregroundStyle(Theme.shared.color.white)
          .padding(.bottom, SPACING_LARGE_MEDIUM)
      }
      .frame(maxWidth: .infinity)
      .padding(.bottom, SPACING_LARGE)
      .background(Theme.shared.color.black)
    }
  }
}

// MARK: - Camera Preview
struct CameraPreview: UIViewRepresentable {
  @ObservedObject var camera: CameraModel

  func makeUIView(context: Context) -> UIView {
    let view = UIView(frame: UIScreen.main.bounds)
    view.backgroundColor = .black

    DispatchQueue.main.async {
      camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
      camera.preview.frame = view.bounds
      camera.preview.videoGravity = .resizeAspectFill
      view.layer.addSublayer(camera.preview)
    }

    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {
    DispatchQueue.main.async {
      camera.preview?.frame = uiView.bounds
    }
  }
}

#Preview {
  let viewState = CameraViewState(camera: CameraModel())
  content(viewState: viewState,
          camera: viewState.camera,
          onBackButtonTapped: {})
}
