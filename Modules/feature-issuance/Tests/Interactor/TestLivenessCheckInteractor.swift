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
import XCTest

@testable import logic_core
@testable import logic_test
@testable import feature_test
@testable import feature_common
@testable import feature_issuance

final class TestLivenessCheckInteractor: EudiTest {

  var interactor: LivenessCheckInteractorImpl!

  override func setUp() {
    super.setUp()
    self.interactor = LivenessCheckInteractorImpl()
  }

  override func tearDown() {
    self.interactor = nil
    super.tearDown()
  }

  // MARK: - prepareAssets

  /// On the simulator, FaceMatchSDK is unavailable; `prepareAssets()` is documented to
  /// return `true` so the UI flow can proceed.
  func testPrepareAssetsOnSimulatorReturnsTrue() async {
    let result = await interactor.prepareAssets()
    XCTAssertTrue(result, "prepareAssets() should report success on the simulator")
  }

  /// `prepareAssets()` must be idempotent — repeated calls must not throw or change the
  /// returned value.
  func testPrepareAssetsWhenCalledMultipleTimesIsIdempotent() async {
    let first = await interactor.prepareAssets()
    let second = await interactor.prepareAssets()
    XCTAssertEqual(first, second, "Subsequent prepareAssets() calls should return the same value")
    XCTAssertTrue(second)
  }

  // MARK: - performLivenessCheck (simulator)

  /// On the simulator, the SDK cannot run, so `performLivenessCheck` must report
  /// `.simulatorNotSupported`.
  func testPerformLivenessCheckOnSimulatorReturnsSimulatorNotSupported() async {
    let dummyImage = Data([0x00])
    let result = await interactor.performLivenessCheck(referenceImageData: dummyImage)
    if case .simulatorNotSupported = result {
      // expected
    } else {
      XCTFail("Expected .simulatorNotSupported on the simulator, got \(result)")
    }
  }
}
