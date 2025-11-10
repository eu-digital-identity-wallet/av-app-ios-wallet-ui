import Foundation
import logic_core
import logic_resources
#if !targetEnvironment(simulator)
import FaceMatchSDK
#endif

public protocol LivenessCheckInteractor: Sendable {
  func performLivenessCheck(referenceImageData: Data) async -> LivenessCheckPartialState
}

final class LivenessCheckInteractorImpl: LivenessCheckInteractor {

  #if !targetEnvironment(simulator)
  private nonisolated(unsafe) let sdk: FaceMatchSDKProtocol = FaceMatchSDKImpl()
  #endif

  init() {
    initializeSDK()
  }

  func performLivenessCheck(referenceImageData: Data) async -> LivenessCheckPartialState {
    #if targetEnvironment(simulator)
    return .simulatorNotSupported
    #else
    // Save photo data to a temporary file for the SDK
    let tempDirectory = FileManager.default.temporaryDirectory
    let refPath = tempDirectory.appendingPathComponent("passport_photo_\(UUID().uuidString).jpg").path
    let refURL = URL(fileURLWithPath: refPath)

    do {
      try referenceImageData.write(to: refURL)
    } catch {
      log("Failed to write reference image to temp file: \(error)", level: .error)
      return .failure(.unableToWriteTempFile)
    }

    // Ensure temporary file is cleaned up when function exits
    defer {
      try? FileManager.default.removeItem(at: refURL)
      log("Cleaned up temporary reference image file", level: .debug)
    }

    log("Starting liveness check with reference image", level: .info)

    // Call the SDK
    let matchResult = await captureAndMatchAsync(referenceImagePath: refPath)

    log("""
      captureAndMatch callback received:
        - processed: \(matchResult.processed)
        - referenceIsValid: \(matchResult.referenceIsValid)
        - capturedIsLive: \(matchResult.capturedIsLive)
        - isSameSubject: \(matchResult.isSameSubject)
        - capturedPath: \(matchResult.capturedPath ?? "nil")
      """, level: .debug)

    // Interpret results
    if matchResult.processed && !matchResult.referenceIsValid {
      return .failure(.invalidReferenceImage)
    } else if !matchResult.capturedIsLive {
      return .failure(.notLive)
    } else if !matchResult.isSameSubject {
      return .failure(.noMatch)
    } else if matchResult.capturedIsLive == true && matchResult.isSameSubject == true {
      return .success
    } else {
      return .failure(.unknown)
    }
    #endif
  }

  #if !targetEnvironment(simulator)
  private nonisolated func captureAndMatchAsync(referenceImagePath: String) async -> (processed: Bool, referenceIsValid: Bool, capturedIsLive: Bool, isSameSubject: Bool, capturedPath: String?) {
    await withUnsafeContinuation { continuation in
      sdk.captureAndMatch(referenceImagePath: referenceImagePath) { result in
        // Extract primitive values immediately to avoid Sendable issues with MatchResult
        let values = (
          processed: result.processed,
          referenceIsValid: result.referenceIsValid,
          capturedIsLive: result.capturedIsLive,
          isSameSubject: result.isSameSubject,
          capturedPath: result.capturedPath
        )
        continuation.resume(returning: values)
      }
    }
  }
  #endif

  private func initializeSDK() {
    #if !targetEnvironment(simulator)
    // Look for config.json in the feature-issuance module bundle
    guard let configUrl = Bundle.module.url(forResource: "config", withExtension: "json"),
          let configData = try? Data(contentsOf: configUrl),
          let configString = String(data: configData, encoding: .utf8) else {
      log("Failed to load config.json from bundle", level: .error)
      // Try to initialize with empty config
      let success = sdk.initSDK(configJson: "{}")
      log(success ? "SDK initialized with empty config" : "SDK initialization failed", level: success ? .warning : .error)
      return
    }

    log("Loaded config.json: \(configString)", level: .debug)
    let success = sdk.initSDK(configJson: configString)
    log(success ? "FaceMatchSDK initialized" : "FaceMatchSDK initialization failed", level: success ? .info : .error)
    #else
    log("FaceMatchSDK not available on simulator", level: .info)
    #endif
  }
}

public enum LivenessCheckPartialState: Sendable {
  case success
  case failure(LivenessCheckError)
  case simulatorNotSupported
}

public enum LivenessCheckError: Sendable {
  case invalidReferenceImage
  case notLive
  case noMatch
  case unableToWriteTempFile
  case unknown
}
