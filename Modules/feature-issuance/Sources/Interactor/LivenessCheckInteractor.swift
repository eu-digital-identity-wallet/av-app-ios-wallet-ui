import Foundation
import UIKit
import os
import logic_core
import logic_resources
#if !targetEnvironment(simulator)
import FaceMatchSDK
#endif

public protocol LivenessCheckInteractor: Sendable {
  func performLivenessCheck(referenceImageData: Data) async -> LivenessCheckPartialState
  /// Prepares verification assets (initializes the FaceMatchSDK). Idempotent.
  /// Returns `true` if the SDK is initialized and ready for liveness capture.
  func prepareAssets() async -> Bool
}

final class LivenessCheckInteractorImpl: LivenessCheckInteractor {

  #if !targetEnvironment(simulator)
  private nonisolated(unsafe) let sdk: FaceMatchSDKProtocol = FaceMatchSDKImpl()
  #endif

  // OSAllocatedUnfairLock is async-safe (unlike NSLock) and Sendable when its
  // state is Sendable. The `initialized` flag is held inside the lock, so all
  // access is serialised via `withLock { ... }`.
  private let initLock = OSAllocatedUnfairLock(initialState: false)

  init() {
    initializeSDK()
  }

  /// Fixed path for passport reference photo - reused across liveness check attempts
  static let passportPhotoPath: String = {
    FileManager.default.temporaryDirectory.appendingPathComponent("passport_reference_photo.jpg").path
  }()

  /// Cleans up any existing passport photo from a previous flow
  static func cleanupPassportPhoto() {
    try? FileManager.default.removeItem(atPath: passportPhotoPath)
  }

  func performLivenessCheck(referenceImageData: Data) async -> LivenessCheckPartialState {
    #if targetEnvironment(simulator)
    return .simulatorNotSupported
    #else
    let refPath = Self.passportPhotoPath

    // Convert passport photo data to standard JPEG format
    // Passport chips store photos in JPEG2000 format (per ICAO 9303), which the SDK may not support
    guard let uiImage = UIImage(data: referenceImageData),
          let jpegData = uiImage.jpegData(compressionQuality: 0.95) else {
      log("Failed to convert reference image to JPEG format", level: .error)
      return .failure(.unableToWriteTempFile)
    }

    do {
      // Overwrite any existing file at this path
      try jpegData.write(to: URL(fileURLWithPath: refPath), options: .atomic)
    } catch {
      log("Failed to write reference image to temp file: \(error)", level: .error)
      return .failure(.unableToWriteTempFile)
    }

    log("Starting liveness check with reference image at: \(refPath)", level: .info)

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
  // swiftlint:disable large_tuple
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
  // swiftlint:enable large_tuple

  func prepareAssets() async -> Bool {
    #if targetEnvironment(simulator)
    // FaceMatchSDK is unavailable on simulator; report success so the UI flow proceeds.
    return true
    #else
    // Run the (synchronous) SDK initialization on a background priority to avoid
    // blocking the caller. The actual work is guarded by `initLock` inside
    // `initializeSDK()` so repeated calls are no-ops.
    await Task.detached(priority: .userInitiated) { [weak self] in
      self?.initializeSDK()
    }.value

    // OSAllocatedUnfairLock.withLock is safe to call from async contexts.
    return initLock.withLock { initialized in
      initialized
    }
    #endif
  }

  private func initializeSDK() {
    #if !targetEnvironment(simulator)
    initLock.withLock { (initialized: inout Bool) in
      // Idempotency: only initialize once per instance lifetime.
      guard !initialized else { return }

      // Look for config.json in the feature-issuance module bundle
      guard let configUrl = Bundle.module.url(forResource: "config", withExtension: "json"),
            let configData = try? Data(contentsOf: configUrl),
            let configString = String(data: configData, encoding: .utf8) else {
        log("Failed to load config.json from bundle", level: .error)
        // Try to initialize with empty config
        let success = sdk.initSDK(configJson: "{}")
        log(success ? "SDK initialized with empty config" : "SDK initialization failed", level: success ? .warning : .error)
        if success { initialized = true }
        return
      }

      log("Loaded config.json: \(configString)", level: .debug)
      let success = sdk.initSDK(configJson: configString)
      log(success ? "FaceMatchSDK initialized" : "FaceMatchSDK initialization failed", level: success ? .info : .error)
      if success { initialized = true }
    }
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
