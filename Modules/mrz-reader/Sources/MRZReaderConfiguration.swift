import Foundation

// MARK: - MRZ Reader Configuration
/// Configuration options for the MRZ Reader module
public struct MRZReaderConfiguration: Sendable {
  /// Enable or disable logging output
  public let loggingEnabled: Bool

  /// Localizable strings for the MRZ Reader UI
  public let strings: LocalizableStrings

  /// Localizable strings used in the MRZ Reader UI
  public struct LocalizableStrings: Sendable {
    /// Status text when MRZ is detected and ready
    public let documentReady: String
    /// Status text when scanning for document
    public let scanning: String
    /// Instruction text to place document in frame
    public let placeDocumentInFrame: String
    /// Error title text
    public let cameraError: String
    /// Error message when camera permission is denied
    public let cameraPermissionDenied: String
    /// Error message when camera setup fails
    public let cameraSetupFailed: String
    /// Error message for unknown errors
    public let unknownError: String
    /// Loading text when initializing camera
    public let initializingCamera: String
    /// Accessibility label for the camera flash/torch toggle button
    public let flashButton: String

    /// Creates a new set of localizable strings
    public init(
      documentReady: String,
      scanning: String,
      placeDocumentInFrame: String,
      cameraError: String,
      cameraPermissionDenied: String,
      cameraSetupFailed: String,
      unknownError: String,
      initializingCamera: String,
      flashButton: String = "Toggle camera flash"
    ) {
      self.documentReady = documentReady
      self.scanning = scanning
      self.placeDocumentInFrame = placeDocumentInFrame
      self.cameraError = cameraError
      self.cameraPermissionDenied = cameraPermissionDenied
      self.cameraSetupFailed = cameraSetupFailed
      self.unknownError = unknownError
      self.initializingCamera = initializingCamera
      self.flashButton = flashButton
    }
  }

  /// Creates a new MRZ Reader configuration
  /// - Parameters:
  ///   - loggingEnabled: Whether to enable logging (default: false)
  ///   - strings: Localizable strings for the UI
  public init(
    loggingEnabled: Bool = false,
    strings: LocalizableStrings
  ) {
    self.loggingEnabled = loggingEnabled
    self.strings = strings
  }

  /// Default configuration with logging disabled and English strings
  public static let `default` = MRZReaderConfiguration(
    loggingEnabled: false,
    strings: LocalizableStrings(
      documentReady: "Document Ready",
      scanning: "Scanning...",
      placeDocumentInFrame: "Place document within the frame",
      cameraError: "Camera Error",
      cameraPermissionDenied: "Camera access denied. Please enable camera permission in Settings.",
      cameraSetupFailed: "Failed to setup camera. Please try again.",
      unknownError: "An unknown error occurred",
      initializingCamera: "Initializing camera...",
      flashButton: "Toggle camera flash"
    )
  )
}

// MARK: - Internal Logger
enum MRZLogger {
  nonisolated(unsafe) static var isEnabled: Bool = false

  static func log(_ message: String, file: String = #file, line: Int = #line) {
    guard isEnabled else { return }
    let filename = (file as NSString).lastPathComponent
    print("📄 [MRZReader] [\(filename):\(line)] \(message)")
  }
}
