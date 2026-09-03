import SwiftUI

// MARK: - Document Scanner View
public struct DocumentScannerView: View {
  @StateObject private var cameraManager = DocumentCameraManager()
  @State private var instructionAreaHeight: CGFloat = InstructionAreaHeightKey.defaultValue
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

        // Document outline guide + bottom instruction text. The document guide is
        // positioned so it never overlaps the instruction text at any Dynamic Type size.
        GeometryReader { geometry in
          // Reserve space at the top (flash toggle + safe area) and at the bottom
          // (status indicator + instruction text measured via PreferenceKey).
          let topReserve: CGFloat = 80
          let bottomReserve = instructionAreaHeight + 24
          let availableHeight = max(geometry.size.height - bottomReserve - topReserve, 200)

          // Size the document guide off the shorter screen dimension so it fits
          // both portrait and landscape without overflowing the available space.
          // Aspect ratio similar to passport/ID card: ~1.42:1 (ID-1).
          let referenceSide = min(geometry.size.width, geometry.size.height)
          let documentWidth = min(referenceSide * 0.68, geometry.size.width - 32)
          let documentHeight = min(documentWidth / 1.42, availableHeight * 0.7)
          let documentRect = CGRect(
            x: (geometry.size.width - documentWidth) / 2,
            y: topReserve + (availableHeight - documentHeight) / 2,
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

          // Overlay: flash toggle (top-right) + status indicator + instruction text (bottom).
          // Both are stacked in a single VStack that fills the geometry so the bottom
          // text height can be measured via PreferenceKey and fed back into the layout.
          VStack(spacing: .zero) {
            // Top bar: flash toggle (only on torch-equipped devices).
            HStack {
              Spacer()
              if cameraManager.isTorchAvailable {
                FlashToggleView(
                  isOn: cameraManager.isTorchOn,
                  label: configuration.strings.flashButton,
                  onToggle: { Task { await cameraManager.toggleTorch() } }
                )
                .padding(.top, 8)
                .padding(.trailing, 16)
              }
            }

            Spacer()

            // Bottom stack: status indicator + placeDocumentInFrame instruction text.
            VStack(spacing: 12) {
              // Status indicator
              HStack(spacing: 12) {
                Circle()
                  .fill(cameraManager.detectionResult?.mrzRect != nil ? Color.green : Color.gray)
                  .frame(width: 12, height: 12)
                Text(cameraManager.detectionResult?.mrzRect != nil ? configuration.strings.documentReady : configuration.strings.scanning)
                  .foregroundColor(.white)
                  .font(.body)
                  .bold()
                  .fixedSize(horizontal: false, vertical: true)
                  .multilineTextAlignment(.center)
              }
              .padding()
              .background(Color.black.opacity(0.7))
              .cornerRadius(12)

              Text(configuration.strings.placeDocumentInFrame)
                .font(.body)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(maxWidth: geometry.size.width - 32, alignment: .center)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(12)
            }
            .background(
              GeometryReader { proxy in
                Color.clear.preference(
                  key: InstructionAreaHeightKey.self,
                  value: proxy.size.height
                )
              }
            )
            .padding(.bottom, 24)
          }
        }
        .onPreferenceChange(InstructionAreaHeightKey.self) { newValue in
          instructionAreaHeight = newValue
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

// MARK: - Instruction area height PreferenceKey

/// Measures the height of the bottom instruction text area so the document guide
/// can be repositioned dynamically to avoid overlapping it at large Dynamic Type sizes.
private struct InstructionAreaHeightKey: PreferenceKey {
  nonisolated(unsafe) static var defaultValue: CGFloat = 180
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = max(value, nextValue())
  }
}

// MARK: - Flash Toggle

/// Native `Toggle`-based flash button exposing the on/off state to VoiceOver.
/// Extracted as a public struct so it can be tested independently of the live camera.
public struct FlashToggleView: View {
  let isOn: Bool
  let label: String
  let onToggle: () -> Void

  public init(isOn: Bool, label: String, onToggle: @escaping () -> Void) {
    self.isOn = isOn
    self.label = label
    self.onToggle = onToggle
  }

  public var body: some View {
    Toggle("", isOn: Binding(
      get: { isOn },
      set: { _ in onToggle() }
    ))
    .toggleStyle(FlashToggleStyle())
    .labelsHidden()
    .accessibilityLabel(label)
    .accessibilityIdentifier("flash_toggle")
    .accessibilityAddTraits(.isButton)
  }
}

/// Custom toggle style that renders a circular flash icon button.
private struct FlashToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button {
      configuration.isOn.toggle()
    } label: {
      Image(systemName: configuration.isOn ? "bolt.fill" : "bolt")
        .font(.title2)
        .foregroundColor(.white)
        .padding(10)
        .background(Color.black.opacity(0.5))
        .clipShape(Circle())
    }
  }
}

// MARK: - Preview
#Preview {
  DocumentScannerView()
}

#Preview("Flash toggle (on)") {
  FlashToggleView(isOn: true, label: "Toggle camera flash", onToggle: {})
    .frame(width: 80, height: 80)
    .background(Color.gray)
}

#Preview("Flash toggle (off)") {
  FlashToggleView(isOn: false, label: "Toggle camera flash", onToggle: {})
    .frame(width: 80, height: 80)
    .background(Color.gray)
}
