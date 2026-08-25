import SwiftUI

// MARK: - Document Scanner View
public struct DocumentScannerView: View {
  @StateObject private var cameraManager = DocumentCameraManager()
  @State private var deviceOrientation: UIDeviceOrientation = .portrait
  private let onMRZCaptured: ((MRZData) -> Void)?
  private let configuration: MRZReaderConfiguration

  public init(
    configuration: MRZReaderConfiguration = .default,
    onMRZCaptured: ((MRZData) -> Void)? = nil
  ) {
    self.configuration = configuration
    self.onMRZCaptured = onMRZCaptured
    MRZLogger.isEnabled = configuration.loggingEnabled
  }

  private func errorMessage(for error: Error) -> String {
    if let cameraError = error as? CameraSessionActor.CameraError {
      switch cameraError {
      case .permissionDenied:
        return configuration.strings.cameraPermissionDenied
      case .setupFailed:
        return configuration.strings.cameraSetupFailed
      }
    }
    return "\(configuration.strings.unknownError): \(error.localizedDescription)"
  }

  public var body: some View {
    ZStack {
      if let session = cameraManager.captureSession, cameraManager.isSessionRunning {
        CameraPreviewView(session: session, deviceOrientation: deviceOrientation)
          .ignoresSafeArea()

        // Fixed alignment guides
        GeometryReader { geometry in
          // Size the document guide off the shorter screen dimension so it fits
          // both portrait and landscape without overflowing the available space.
          // Aspect ratio similar to passport/ID card: ~1.42:1 (ID-1).
          let referenceSide = min(geometry.size.width, geometry.size.height)
          let documentWidth = referenceSide * 0.68
          let documentHeight: CGFloat = documentWidth / 1.42  // Standard ID-1 aspect ratio
          let documentRect = CGRect(
            x: (geometry.size.width - documentWidth) / 2,
            y: (geometry.size.height - documentHeight) / 2,
            width: documentWidth,
            height: documentHeight
          )

          // Document guide with corner markers
          Path { path in
            let cornerLength: CGFloat = 30
            // Top-left corner
            path.move(to: CGPoint(x: documentRect.minX, y: documentRect.minY + cornerLength))
            path.addLine(to: CGPoint(x: documentRect.minX, y: documentRect.minY))
            path.addLine(to: CGPoint(x: documentRect.minX + cornerLength, y: documentRect.minY))

            // Top-right corner
            path.move(to: CGPoint(x: documentRect.maxX - cornerLength, y: documentRect.minY))
            path.addLine(to: CGPoint(x: documentRect.maxX, y: documentRect.minY))
            path.addLine(to: CGPoint(x: documentRect.maxX, y: documentRect.minY + cornerLength))

            // Bottom-left corner
            path.move(to: CGPoint(x: documentRect.minX, y: documentRect.maxY - cornerLength))
            path.addLine(to: CGPoint(x: documentRect.minX, y: documentRect.maxY))
            path.addLine(to: CGPoint(x: documentRect.minX + cornerLength, y: documentRect.maxY))

            // Bottom-right corner
            path.move(to: CGPoint(x: documentRect.maxX - cornerLength, y: documentRect.maxY))
            path.addLine(to: CGPoint(x: documentRect.maxX, y: documentRect.maxY))
            path.addLine(to: CGPoint(x: documentRect.maxX, y: documentRect.maxY - cornerLength))
          }
          .stroke(Color.white, lineWidth: 3)

          // Bottom text area guide (where machine-readable zone is)
          let textAreaHeight: CGFloat = 70  // Reduced height for 2-3 lines of text
          let textAreaWidth = documentWidth - 40
          let textAreaRect = CGRect(
            x: (geometry.size.width - textAreaWidth) / 2,
            y: documentRect.maxY - textAreaHeight - 15,
            width: textAreaWidth,
            height: textAreaHeight
          )

          // MRZ guide changes color and thickness when detected
          let isMRZDetected = cameraManager.detectionResult?.mrzRect != nil
          Path(textAreaRect)
            .stroke(
              isMRZDetected ? Color.green : Color.white.opacity(0.5),
              style: StrokeStyle(
                lineWidth: isMRZDetected ? 4 : 2,
                dash: isMRZDetected ? [] : [8, 4]
              )
            )
        }

        VStack {
          Spacer()

          // Status indicator
          HStack(spacing: 12) {
            Circle()
              .fill(cameraManager.detectionResult?.mrzRect != nil ? Color.green : Color.gray)
              .frame(width: 12, height: 12)
            Text(cameraManager.detectionResult?.mrzRect != nil ? configuration.strings.documentReady : configuration.strings.scanning)
              .foregroundColor(.white)
              .font(.subheadline)
              .bold()
          }
          .padding()
          .background(Color.black.opacity(0.7))
          .cornerRadius(12)

          Text(configuration.strings.placeDocumentInFrame)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(12)

          Spacer()
            .frame(height: 24)
        }
      } else {
        if let error = cameraManager.error {
          VStack {
            Text(configuration.strings.cameraError)
              .font(.headline)
              .foregroundColor(.white)
            Text(errorMessage(for: error))
              .foregroundColor(.white)
              .multilineTextAlignment(.center)
              .padding()
          }
        } else {
          ProgressView(configuration.strings.initializingCamera)
            .foregroundColor(.white)
        }
      }
    }
    .task {
      do {
        MRZLogger.log("Setting up camera...")
        if let handler = onMRZCaptured {
          cameraManager.setOnMRZCaptured(handler)
        }
        try await cameraManager.setupCamera()
        MRZLogger.log("Camera setup successful")
        // Push the current orientation once the session is up so an already-landscape
        // launch is handled correctly (the change notification only fires on rotation).
        let orientation = UIDevice.current.orientation
        deviceOrientation = orientation
        await cameraManager.updateOrientation(orientation)
      } catch {
        MRZLogger.log("Camera setup failed: \(error)")
        cameraManager.error = error
      }
    }
    .onAppear {
      UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
      let orientation = UIDevice.current.orientation
      guard orientation != deviceOrientation else { return }
      deviceOrientation = orientation
      Task { await cameraManager.updateOrientation(orientation) }
    }
    .onDisappear {
      UIDevice.current.endGeneratingDeviceOrientationNotifications()
      Task {
        await cameraManager.stopCamera()
      }
    }
  }
}

// MARK: - Preview
#Preview {
  DocumentScannerView()
}
