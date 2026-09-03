import SwiftUI
@preconcurrency import AVFoundation

// MARK: - Camera Preview UIView
@MainActor
final class CameraPreviewUIView: UIView {
  /// Current device orientation, supplied by the hosting SwiftUI view.
  var deviceOrientation: UIDeviceOrientation = .portrait
  private var lastStableOrientation: UIDeviceOrientation = .portrait

  override class var layerClass: AnyClass {
    AVCaptureVideoPreviewLayer.self
  }

  var previewLayer: AVCaptureVideoPreviewLayer? {
    layer as? AVCaptureVideoPreviewLayer
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    updateOrientation()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    updateOrientation()
  }

  /// Rotates the preview layer to match the current device orientation.
  /// `faceUp`, `faceDown` and `unknown` fall back to the last stable orientation
  /// to avoid jitter when the device is laid flat.
  func updateOrientation() {
    let orientation: UIDeviceOrientation
    switch deviceOrientation {
    case .portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight:
      orientation = deviceOrientation
      lastStableOrientation = deviceOrientation
    default:
      orientation = lastStableOrientation
    }

    guard let connection = previewLayer?.connection,
          connection.isVideoOrientationSupported else { return }
    connection.videoOrientation = AVCaptureVideoOrientation(uiDeviceOrientation: orientation)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    if let previewLayer = previewLayer {
      previewLayer.frame = bounds
    }
    updateOrientation()
  }
}

extension AVCaptureVideoOrientation {
  init(uiDeviceOrientation orientation: UIDeviceOrientation) {
    // UIDeviceOrientation and AVCaptureVideoOrientation use opposite
    // left/right conventions for landscape, so swap them (per Apple AVCam).
    switch orientation {
    case .portrait: self = .portrait
    case .portraitUpsideDown: self = .portraitUpsideDown
    case .landscapeLeft: self = .landscapeRight
    case .landscapeRight: self = .landscapeLeft
    default: self = .portrait
    }
  }
}

// MARK: - Camera Preview View
struct CameraPreviewView: UIViewRepresentable {
  let session: AVCaptureSession
  let deviceOrientation: UIDeviceOrientation

  func makeUIView(context: Context) -> CameraPreviewUIView {
    let view = CameraPreviewUIView(frame: .zero)
    view.backgroundColor = .black
    view.deviceOrientation = deviceOrientation
    if let previewLayer = view.previewLayer {
      previewLayer.session = session
      previewLayer.videoGravity = .resizeAspectFill
    }
    return view
  }

  func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
    uiView.deviceOrientation = deviceOrientation
    uiView.updateOrientation()
  }
}

// MARK: - Overlay Shape View
struct OverlayShape: Shape {
  let rect: CGRect
  let padding: CGFloat
  let deviceOrientation: UIDeviceOrientation

  init(
    rect: CGRect,
    padding: CGFloat = 0.0,
    deviceOrientation: UIDeviceOrientation = .portrait
  ) {
    self.rect = rect
    self.padding = padding
    self.deviceOrientation = deviceOrientation
  }

  func path(in rect: CGRect) -> Path {
    // Vision uses normalized coordinates (0-1) with origin at bottom-left.
    // The conversion to screen coordinates depends on the CGImagePropertyOrientation
    // applied to the VNImageRequestHandler, which mirrors the device orientation
    // (see CameraSessionActor.visionOrientation).
    let nx = self.rect.minX
    let ny = self.rect.minY
    let nw = self.rect.width
    let nh = self.rect.height

    let convertedRect: CGRect
    switch deviceOrientation {
    case .portrait:
      // Vision orientation .right: swap x/y and flip new-x
      convertedRect = CGRect(
        x: rect.width * ny,
        y: rect.height * (1 - nx - nw),
        width: rect.width * nh,
        height: rect.height * nw
      )
    case .portraitUpsideDown:
      // Vision orientation .left: swap x/y and flip new-y
      convertedRect = CGRect(
        x: rect.width * (1 - ny - nh),
        y: rect.height * nx,
        width: rect.width * nh,
        height: rect.height * nw
      )
    case .landscapeLeft:
      // Vision orientation .up: coordinates already align with screen
      convertedRect = CGRect(
        x: rect.width * nx,
        y: rect.height * (1 - ny - nh),
        width: rect.width * nw,
        height: rect.height * nh
      )
    case .landscapeRight:
      // Vision orientation .down: flip both axes
      convertedRect = CGRect(
        x: rect.width * (1 - nx - nw),
        y: rect.height * ny,
        width: rect.width * nw,
        height: rect.height * nh
      )
    default:
      // faceUp / faceDown / unknown -> fall back to portrait mapping
      convertedRect = CGRect(
        x: rect.width * ny,
        y: rect.height * (1 - nx - nw),
        width: rect.width * nh,
        height: rect.height * nw
      )
    }

    // Apply padding if specified (in normalized coordinates)
    let finalRect: CGRect
    if padding > 0 {
      let paddingX = rect.width * padding
      let paddingY = rect.height * padding
      finalRect = convertedRect.insetBy(dx: -paddingX, dy: -paddingY)
    } else {
      finalRect = convertedRect
    }

    return Path(finalRect)
  }
}
