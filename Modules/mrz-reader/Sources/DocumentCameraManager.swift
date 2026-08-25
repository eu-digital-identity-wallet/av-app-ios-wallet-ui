import SwiftUI
@preconcurrency import AVFoundation

// MARK: - Document Camera Manager
@MainActor
class DocumentCameraManager: ObservableObject, CameraSessionDelegate {
  @Published var captureSession: AVCaptureSession?
  @Published var detectionResult: DetectionResult?
  @Published var error: Error?
  @Published var isSessionRunning = false
  @Published var capturedMRZ: MRZData?

  private var sessionActor: CameraSessionActor?
  private var previousMRZ: MRZData?
  private var previousMRZTimestamp: Date?
  private var consecutiveMatchCount = 0
  private var onMRZCaptured: ((MRZData) -> Void)?

  func setOnMRZCaptured(_ handler: @escaping (MRZData) -> Void) {
    self.onMRZCaptured = handler
  }

  func setupCamera() async throws {
    let actor = CameraSessionActor()
    await actor.setDelegate(self)

    let session = try await actor.setup()
    self.captureSession = session
    self.sessionActor = actor

    await actor.start()
    self.isSessionRunning = true
  }

  func stopCamera() async {
    await sessionActor?.stop()
    self.isSessionRunning = false
  }

  /// Forward a device orientation change to the camera session so that the
  /// video output connection and Vision request handler stay in sync with the
  /// current screen orientation.
  func updateOrientation(_ orientation: UIDeviceOrientation) async {
    await sessionActor?.updateOrientation(orientation)
  }

  func resetForNewScan() async {
    // Reset all state without stopping the camera
    await MainActor.run {
      capturedMRZ = nil
      detectionResult = nil
      previousMRZ = nil
      previousMRZTimestamp = nil
      consecutiveMatchCount = 0
    }

    // Restart the session if it's not running
    if !isSessionRunning {
      await sessionActor?.start()
      isSessionRunning = true
    }
  }

  nonisolated func didUpdateDetection(_ result: DetectionResult) {
    Task { @MainActor in
      self.detectionResult = result

      // Handle auto-capture only after two consecutive matching valid MRZ detections
      if let mrzData = result.mrzData, self.capturedMRZ == nil {
        let currentTime = Date()

        // Check if the previous detection is older than 3 seconds
        if let timestamp = self.previousMRZTimestamp,
           currentTime.timeIntervalSince(timestamp) > 3.0 {
          // Reset if too much time has passed
          self.previousMRZ = mrzData
          self.previousMRZTimestamp = currentTime
          self.consecutiveMatchCount = 1
        }
        // Check if this MRZ matches the previous one
        else if let previousMRZ = self.previousMRZ, previousMRZ.rawMRZ == mrzData.rawMRZ {
          // We have a match! Increment the counter
          self.consecutiveMatchCount += 1
          self.previousMRZTimestamp = currentTime

          // If we've seen this MRZ twice in a row, accept it
          if self.consecutiveMatchCount >= 2 {
            self.capturedMRZ = mrzData
            await self.stopCamera()
            // Call the completion handler
            self.onMRZCaptured?(mrzData)
          }
        } else {
          // New MRZ detected, reset the counter
          self.previousMRZ = mrzData
          self.previousMRZTimestamp = currentTime
          self.consecutiveMatchCount = 1
        }
      }
    }
  }
}
