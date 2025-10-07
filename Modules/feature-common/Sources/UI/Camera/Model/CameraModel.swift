import AVFoundation

// MARK: - Camera Model
class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
  @Published var session = AVCaptureSession()
  @Published var preview: AVCaptureVideoPreviewLayer!
  @Published var capturedImage: UIImage?

  private let output = AVCapturePhotoOutput()

  func checkPermissions() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      setUp()
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { [weak self] status in
        if status {
          self?.setUp()
        }
      }
    case .denied, .restricted:
      print("Camera access denied")
    @unknown default:
      break
    }
  }

  func setUp() {
    do {
      session.beginConfiguration()

      guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                 for: .video,
                                                 position: .back) else {
        print("No camera device found")
        return
      }

      let input = try AVCaptureDeviceInput(device: device)

      if session.canAddInput(input) {
        session.addInput(input)
      }

      if session.canAddOutput(output) {
        session.addOutput(output)
      }

      session.commitConfiguration()

      // Start session on background thread
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        self?.session.startRunning()
      }
    } catch {
      print("Error setting up camera: \(error.localizedDescription)")
    }
  }

  func capturePhoto() {
    let settings = AVCapturePhotoSettings()
    output.capturePhoto(with: settings, delegate: self)
  }

  func stopSession() {
    if session.isRunning {
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        self?.session.stopRunning()
      }
    }
  }

  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    if let error = error {
      print("Error capturing photo: \(error.localizedDescription)")
      return
    }
    guard let imageData = photo.fileDataRepresentation(),
          let image = UIImage(data: imageData) else {
      return
    }
    capturedImage = image
  }
}
