/*
 * Copyright (c) 2026 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */

// Unit tests for `DocumentCameraManager` initial state.
//
// The actual torch toggle and camera setup require a physical device with a torch
// and an AVCaptureSession, so they cannot be exercised on the simulator. We
// therefore only assert the public state surface that is observable without
// a live camera.
import XCTest

@testable import mrz_reader

@MainActor
final class TestDocumentCameraManager: XCTestCase {

  func testInitialStateWhenCreatedTorchIsOffAndUnavailable() {
    let manager = DocumentCameraManager()
    XCTAssertFalse(manager.isTorchOn, "Torch should be off by default")
    XCTAssertFalse(manager.isTorchAvailable, "Torch availability should be false until a camera is set up")
  }

  func testInitialStateWhenCreatedSessionIsNotRunning() {
    let manager = DocumentCameraManager()
    XCTAssertFalse(manager.isSessionRunning)
    XCTAssertNil(manager.capturedMRZ)
    XCTAssertNil(manager.captureSession)
    XCTAssertNil(manager.detectionResult)
    XCTAssertNil(manager.error)
  }
}
