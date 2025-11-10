import Vision
@preconcurrency import AVFoundation
import CoreGraphics

// MARK: - Camera Session Delegate Protocol
@MainActor
protocol CameraSessionDelegate: AnyObject, Sendable {
  func didUpdateDetection(_ result: DetectionResult)
}

// MARK: - Camera Session Actor
actor CameraSessionActor: NSObject {
  private var captureSession: AVCaptureSession?
  private var videoOutput: AVCaptureVideoDataOutput?
  private var isProcessing = false
  private var processingTask: Task<Void, Never>?

  weak var delegate: CameraSessionDelegate?

  func setup() async throws -> AVCaptureSession {
    // Request camera permission first
    let permissionStatus = AVCaptureDevice.authorizationStatus(for: .video)
    if permissionStatus != .authorized {
      let granted = await AVCaptureDevice.requestAccess(for: .video)
      if !granted {
        throw CameraError.permissionDenied
      }
    }

    let session = AVCaptureSession()
    session.beginConfiguration()
    session.sessionPreset = .photo

    guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
          let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
          session.canAddInput(videoInput) else {
      throw CameraError.setupFailed
    }

    session.addInput(videoInput)

    let output = AVCaptureVideoDataOutput()
    output.alwaysDiscardsLateVideoFrames = true

    guard session.canAddOutput(output) else {
      throw CameraError.setupFailed
    }

    session.addOutput(output)

    // Set the video output connection orientation
    if let connection = output.connection(with: .video),
       connection.isVideoOrientationSupported {
      connection.videoOrientation = .portrait
    }

    session.commitConfiguration()

    self.captureSession = session
    self.videoOutput = output

    // Set delegate directly - the actor will handle thread safety
    output.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInitiated))

    return session
  }

  func start() async {
    captureSession?.startRunning()
  }

  func stop() async {
    processingTask?.cancel()
    captureSession?.stopRunning()
  }

  private func notifyDelegate(_ result: DetectionResult) async {
    if let delegate = self.delegate {
      await delegate.didUpdateDetection(result)
    }
  }

  func processFrameAndNotify(_ pixelBuffer: CVPixelBuffer) async {
    let result = await processFrame(pixelBuffer)
    await notifyDelegate(result)
  }

  private func processFrame(_ pixelBuffer: CVPixelBuffer) async -> DetectionResult {
    guard !isProcessing else {
      return DetectionResult(documentRect: nil, mrzRect: nil, mrzData: nil)
    }

    isProcessing = true
    defer { isProcessing = false }

    let documentRequest = VNDetectDocumentSegmentationRequest()
    let textRequest = VNRecognizeTextRequest()
    textRequest.recognitionLevel = .accurate
    textRequest.usesLanguageCorrection = false

    // Set proper orientation for Vision requests
    let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])

    do {
      try handler.perform([documentRequest, textRequest])

      var documentRect: CGRect?
      var mrzRect: CGRect?
      var mrzData: MRZData?

      // Get document bounds
      if let documentObservation = documentRequest.results?.first {
        documentRect = documentObservation.boundingBox
      }

      // Process text for machine-readable zone
      if let textObservations = textRequest.results {
        let (rect, data) = extractMRZ(from: textObservations)
        mrzRect = rect
        mrzData = data
      }

      return DetectionResult(
        documentRect: documentRect,
        mrzRect: mrzRect,
        mrzData: mrzData
      )
    } catch {
      return DetectionResult(documentRect: nil, mrzRect: nil, mrzData: nil)
    }
  }

  private func expandRect(_ rect: CGRect, padding: CGFloat) -> CGRect {
    // Expand rectangle by padding amount (in normalized coordinates 0-1)
    return rect.insetBy(dx: -padding, dy: -padding)
  }

  private func extractMRZ(from observations: [VNRecognizedTextObservation]) -> (CGRect?, MRZData?) {
    var mrzLines: [(String, CGRect)] = []

    for observation in observations {
      guard let topCandidate = observation.topCandidates(1).first else { continue }
      var text = topCandidate.string.replacingOccurrences(of: " ", with: "").uppercased()

      // Clean up common OCR mistakes for angle brackets
      text = text.replacingOccurrences(of: "«", with: "<")
      text = text.replacingOccurrences(of: "»", with: "<")
      text = text.replacingOccurrences(of: "‹", with: "<")
      text = text.replacingOccurrences(of: "›", with: "<")

      // Check if line looks like MRZ (TD1: 30 chars, TD2: 36 chars, TD3: 44 chars)
      if text.count >= 30 && (text.contains("<") || text.range(of: "^[A-Z0-9<]+$", options: .regularExpression) != nil) {
        mrzLines.append((text, observation.boundingBox))
      }
    }

    // Try different MRZ formats

    // Try TD3 (passport) - 2 lines of 44 characters
    let td3Lines = mrzLines.filter { $0.0.count == 44 }
    if td3Lines.count >= 2 {
      let rawMRZ = td3Lines[0].0 + "\n" + td3Lines[1].0
      if MRZValidator.isValidMRZWithCheckDigits(rawMRZ) {
        // Expand the bounding box to include some padding
        let rect = expandRect(td3Lines[0].1.union(td3Lines[1].1), padding: 0.02)
        if let documentData = parseTD3MRZ(line1: td3Lines[0].0, line2: td3Lines[1].0) {
          return (rect, documentData)
        }
      }
    }

    // Try TD2 (official documents) - 2 lines of 36 characters
    let td2Lines = mrzLines.filter { $0.0.count == 36 }
    if td2Lines.count >= 2 {
      let rawMRZ = td2Lines[0].0 + "\n" + td2Lines[1].0
      if MRZValidator.isValidMRZWithCheckDigits(rawMRZ) {
        // Expand the bounding box to include some padding
        let rect = expandRect(td2Lines[0].1.union(td2Lines[1].1), padding: 0.02)
        if let documentData = parseTD2MRZ(line1: td2Lines[0].0, line2: td2Lines[1].0) {
          return (rect, documentData)
        }
      }
    }

    // Try TD1 (ID cards) - 3 lines of 30 characters
    let td1Lines = mrzLines.filter { $0.0.count == 30 }
    if td1Lines.count >= 3 {
      let rawMRZ = td1Lines[0].0 + "\n" + td1Lines[1].0 + "\n" + td1Lines[2].0
      if MRZValidator.isValidMRZWithCheckDigits(rawMRZ) {
        // Expand the bounding box to include some padding
        let rect = expandRect(td1Lines[0].1.union(td1Lines[1].1).union(td1Lines[2].1), padding: 0.02)
        if let documentData = parseTD1MRZ(line1: td1Lines[0].0, line2: td1Lines[1].0, line3: td1Lines[2].0) {
          return (rect, documentData)
        }
      }
    }

    return (nil, nil)
  }

  private func parseTD3MRZ(line1: String, line2: String) -> MRZData? {
    guard line1.count == 44, line2.count == 44 else { return nil }

    // Line 1: P<ISSUINGCOUNTRY<SURNAME<<GIVENNAMES
    let documentType = String(line1.prefix(2)).replacingOccurrences(of: "<", with: "")
    let issuingCountry = String(line1.dropFirst(2).prefix(3)).replacingOccurrences(of: "<", with: "")
    let nameSection = String(line1.dropFirst(5))
    let nameComponents = nameSection.components(separatedBy: "<<")
    let surname = nameComponents.first?.replacingOccurrences(of: "<", with: " ").trimmingCharacters(in: .whitespaces) ?? ""
    let givenNames = nameComponents.count > 1 ? nameComponents[1].replacingOccurrences(of: "<", with: " ").trimmingCharacters(in: .whitespaces) : ""

    // Line 2: DOCUMENTNUMBER<NATIONALITY<DATEOFBIRTH<SEX<EXPIRATIONDATE<PERSONALNUMBER
    let documentNumber = String(line2.prefix(9)).replacingOccurrences(of: "<", with: "")
    let nationality = String(line2.dropFirst(10).prefix(3)).replacingOccurrences(of: "<", with: "")
    let dateOfBirth = String(line2.dropFirst(13).prefix(6))
    let sex = String(line2.dropFirst(20).prefix(1))
    let expirationDate = String(line2.dropFirst(21).prefix(6))
    let personalNumber = String(line2.dropFirst(28).prefix(14)).replacingOccurrences(of: "<", with: "")

    return MRZData(
      documentType: documentType,
      documentNumber: documentNumber,
      issuingCountry: issuingCountry,
      surname: surname,
      givenNames: givenNames,
      nationality: nationality,
      dateOfBirth: formatDate(dateOfBirth),
      sex: sex,
      expirationDate: formatDate(expirationDate),
      personalNumber: personalNumber,
      rawMRZ: line1 + "\n" + line2,
      mrzType: .td3
    )
  }

  private func parseTD2MRZ(line1: String, line2: String) -> MRZData? {
    guard line1.count == 36, line2.count == 36 else { return nil }

    // Line 1: DOCUMENTTYPE<ISSUINGCOUNTRY<SURNAME<<GIVENNAMES
    let documentType = String(line1.prefix(2)).replacingOccurrences(of: "<", with: "")
    let issuingCountry = String(line1.dropFirst(2).prefix(3)).replacingOccurrences(of: "<", with: "")
    let nameSection = String(line1.dropFirst(5))
    let nameComponents = nameSection.components(separatedBy: "<<")
    let surname = nameComponents.first?.replacingOccurrences(of: "<", with: " ").trimmingCharacters(in: .whitespaces) ?? ""
    let givenNames = nameComponents.count > 1 ? nameComponents[1].replacingOccurrences(of: "<", with: " ").trimmingCharacters(in: .whitespaces) : ""

    // Line 2: DOCUMENTNUMBER<NATIONALITY<DATEOFBIRTH<SEX<EXPIRATIONDATE<
    let documentNumber = String(line2.prefix(9)).replacingOccurrences(of: "<", with: "")
    let nationality = String(line2.dropFirst(10).prefix(3)).replacingOccurrences(of: "<", with: "")
    let dateOfBirth = String(line2.dropFirst(13).prefix(6))
    let sex = String(line2.dropFirst(20).prefix(1))
    let expirationDate = String(line2.dropFirst(21).prefix(6))

    return MRZData(
      documentType: documentType,
      documentNumber: documentNumber,
      issuingCountry: issuingCountry,
      surname: surname,
      givenNames: givenNames,
      nationality: nationality,
      dateOfBirth: formatDate(dateOfBirth),
      sex: sex,
      expirationDate: formatDate(expirationDate),
      personalNumber: "",
      rawMRZ: line1 + "\n" + line2,
      mrzType: .td2
    )
  }

  private func parseTD1MRZ(line1: String, line2: String, line3: String) -> MRZData? {
    guard line1.count == 30, line2.count == 30, line3.count == 30 else { return nil }

    // Line 1: DOCUMENTTYPE<ISSUINGCOUNTRY<DOCUMENTNUMBER<
    let documentType = String(line1.prefix(2)).replacingOccurrences(of: "<", with: "")
    let issuingCountry = String(line1.dropFirst(2).prefix(3)).replacingOccurrences(of: "<", with: "")
    let documentNumber = String(line1.dropFirst(5).prefix(9)).replacingOccurrences(of: "<", with: "")

    // Line 2: DATEOFBIRTH<SEX<EXPIRATIONDATE<NATIONALITY<<<
    let dateOfBirth = String(line2.prefix(6))
    let sex = String(line2.dropFirst(7).prefix(1))
    let expirationDate = String(line2.dropFirst(8).prefix(6))
    let nationality = String(line2.dropFirst(15).prefix(3)).replacingOccurrences(of: "<", with: "")

    // Line 3: SURNAME<<GIVENNAMES<<<<<<<<<<<<<
    let nameSection = String(line3)
    let nameComponents = nameSection.components(separatedBy: "<<")
    let surname = nameComponents.first?.replacingOccurrences(of: "<", with: " ").trimmingCharacters(in: .whitespaces) ?? ""
    let givenNames = nameComponents.count > 1 ? nameComponents[1].replacingOccurrences(of: "<", with: " ").trimmingCharacters(in: .whitespaces) : ""

    return MRZData(
      documentType: documentType,
      documentNumber: documentNumber,
      issuingCountry: issuingCountry,
      surname: surname,
      givenNames: givenNames,
      nationality: nationality,
      dateOfBirth: formatDate(dateOfBirth),
      sex: sex,
      expirationDate: formatDate(expirationDate),
      personalNumber: "",
      rawMRZ: line1 + "\n" + line2 + "\n" + line3,
      mrzType: .td1
    )
  }

  private func formatDate(_ mrzDate: String) -> String {
    guard mrzDate.count == 6 else { return mrzDate }
    let year = String(mrzDate.prefix(2))
    let month = String(mrzDate.dropFirst(2).prefix(2))
    let day = String(mrzDate.suffix(2))
    return "\(day)/\(month)/\(year)"
  }

  enum CameraError: Error {
    case setupFailed
    case permissionDenied
  }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraSessionActor: AVCaptureVideoDataOutputSampleBufferDelegate {
  nonisolated func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

    // Use @unchecked Sendable wrapper to handle CVPixelBuffer sendability
    let sendablePixelBuffer = UncheckedSendableWrapper(pixelBuffer)

    Task {
      await self.processFrameAndNotify(sendablePixelBuffer.value)
    }
  }
}

// MARK: - Actor Extension for Delegate
extension CameraSessionActor {
  func setDelegate(_ delegate: CameraSessionDelegate) async {
    self.delegate = delegate
  }
}
