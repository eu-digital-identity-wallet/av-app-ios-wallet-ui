import SwiftUI
@preconcurrency import AVFoundation

// MARK: - Camera Preview UIView
class CameraPreviewUIView: UIView {
  override class var layerClass: AnyClass {
    AVCaptureVideoPreviewLayer.self
  }

  var previewLayer: AVCaptureVideoPreviewLayer? {
    layer as? AVCaptureVideoPreviewLayer
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    if let previewLayer = previewLayer {
        previewLayer.frame = bounds
    }
  }
}

// MARK: - Camera Preview View
struct CameraPreviewView: UIViewRepresentable {
  let session: AVCaptureSession

  func makeUIView(context: Context) -> CameraPreviewUIView {
    let view = CameraPreviewUIView(frame: .zero)
    view.backgroundColor = .black
    if let previewLayer = view.previewLayer {
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill

        // Set the correct orientation for the preview layer
        if let connection = previewLayer.connection,
           connection.isVideoOrientationSupported {
          connection.videoOrientation = .portrait
        }
    }

    return view
  }

  func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
    // The frame will be updated automatically via layoutSubviews
  }
}

// MARK: - Overlay Shape View
struct OverlayShape: Shape {
  let rect: CGRect
  let padding: CGFloat

  init(rect: CGRect, padding: CGFloat = 0.0) {
    self.rect = rect
    self.padding = padding
  }

  func path(in rect: CGRect) -> Path {
    // Vision uses normalized coordinates (0-1) with origin at bottom-left
    // We need to convert to screen coordinates for portrait orientation
    // The image is rotated 90° right (.right orientation in handler)

    // For .right orientation, we swap and flip coordinates
    var convertedRect = CGRect(
      x: rect.width * self.rect.minY,
      y: rect.height * (1 - self.rect.maxX),
      width: rect.width * self.rect.height,
      height: rect.height * self.rect.width
    )

    // Apply padding if specified (in normalized coordinates)
    if padding > 0 {
      let paddingX = rect.width * padding
      let paddingY = rect.height * padding
      convertedRect = convertedRect.insetBy(dx: -paddingX, dy: -paddingY)
    }

    return Path(convertedRect)
  }
}
