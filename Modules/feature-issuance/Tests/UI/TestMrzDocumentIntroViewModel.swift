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
import Cuckoo

@testable import logic_core
@testable import logic_test
@testable import feature_test
@testable import feature_common
@testable import feature_issuance

@MainActor
final class TestMrzDocumentIntroViewModel: EudiTest {

  var router: MockRouterHost!
  var interactor: MockLivenessCheckInteractor!

  override func setUp() {
    super.setUp()
    self.router = MockRouterHost()
    self.interactor = MockLivenessCheckInteractor()
    // Default stub: prepareAssets() succeeds.
    stub(interactor) { mock in
      when(mock.prepareAssets()).thenReturn(true)
    }
  }

  override func tearDown() {
    router = nil
    interactor = nil
    super.tearDown()
  }

  private func makeViewModel() -> MrzDocumentIntroViewModel<MockRouterHost> {
    MrzDocumentIntroViewModel(
      router: router,
      interactor: interactor,
      config: DocumentEnrollmentUiConfig()
    )
  }

  // MARK: - Initial state

  func testInitialStateWhenCreatedThenDownloadNotStarted() {
    let vm = makeViewModel()
    XCTAssertEqual(vm.viewState.downloadProgress, 0)
    XCTAssertFalse(vm.viewState.isDownloading)
    XCTAssertFalse(vm.viewState.downloadComplete)
    XCTAssertFalse(vm.viewState.downloadFailed)
  }

  // MARK: - Happy path

  func testStartAssetDownloadWhenInitSucceedsTransitionsThroughDownloadingToComplete() async {
    let vm = makeViewModel()

    vm.startAssetDownload()

    // Wait for downloadComplete to become true. The throttled loop runs nine 200 ms steps,
    // so the whole flow takes around 2 seconds.
    let expectation = XCTNSPredicateExpectation(
      predicate: NSPredicate { _, _ in vm.viewState.downloadComplete },
      object: nil
    )
    await fulfillment(of: [expectation], timeout: 10.0)

    XCTAssertTrue(vm.viewState.downloadComplete)
    XCTAssertFalse(vm.viewState.isDownloading)
    XCTAssertEqual(vm.viewState.downloadProgress, 100)
    XCTAssertFalse(vm.viewState.downloadFailed)
  }

  // MARK: - Failure path

  func testStartAssetDownloadWhenInitFailsSetsDownloadFailed() async {
    stub(interactor) { mock in
      when(mock.prepareAssets()).thenReturn(false)
    }
    let vm = makeViewModel()

    vm.startAssetDownload()

    let expectation = XCTNSPredicateExpectation(
      predicate: NSPredicate { _, _ in vm.viewState.downloadFailed || vm.viewState.downloadComplete },
      object: nil
    )
    await fulfillment(of: [expectation], timeout: 10.0)

    XCTAssertTrue(vm.viewState.downloadFailed)
    XCTAssertFalse(vm.viewState.downloadComplete)
    XCTAssertFalse(vm.viewState.isDownloading)
  }

  // MARK: - Idempotency

  func testStartAssetDownloadWhenAlreadyCompleteIsIdempotent() async {
    let vm = makeViewModel()

    vm.startAssetDownload()
    let firstExpectation = XCTNSPredicateExpectation(
      predicate: NSPredicate { _, _ in vm.viewState.downloadComplete },
      object: nil
    )
    await fulfillment(of: [firstExpectation], timeout: 10.0)
    let progressAfterFirst = vm.viewState.downloadProgress
    XCTAssertTrue(vm.viewState.downloadComplete)

    // Calling again should not restart the download.
    vm.startAssetDownload()
    try? await Task.sleep(nanoseconds: 500_000_000)  // allow any spurious task to advance

    XCTAssertEqual(vm.viewState.downloadProgress, progressAfterFirst)
    XCTAssertTrue(vm.viewState.downloadComplete)
    XCTAssertFalse(vm.viewState.isDownloading)
  }
}
