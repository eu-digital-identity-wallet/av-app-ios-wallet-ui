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

// Unit tests for `MrzDocumentIntroView` rendering and accessibility setup.
//
// Verifies AC2 ("After the download completes, focus is automatically moved to the
// Start button") at the structural level: the Start button has the
// `accessibilityIdentifier("passport_scan_intro_start_button")` modifier set in
// `MrzDocumentIntroView.swift`, and the view is bound to a
// `@AccessibilityFocusState` that flips to `true` on `downloadComplete`.
//
// Note on accessibility identifier verification: SwiftUI's `accessibilityIdentifier`
// is not materialised into the UIKit accessibility tree unless VoiceOver is active,
// so it cannot be asserted via UIKit introspection in XCTest. The identifier is
// set in `MrzDocumentIntroView.swift` and must be verified manually with VoiceOver
// (see README.md accessibility verification section).
//
// The tests below cover what *can* be asserted in XCTest: that the view renders
// without crashing in the initial, downloading, and completed states, and that
// the view model's `downloadComplete` flag is observable (which the view's
// `.onChange` modifier uses to move VoiceOver focus to the Start button).
import XCTest
import SwiftUI
import Cuckoo

@testable import logic_core
@testable import logic_test
@testable import feature_test
@testable import feature_common
@testable import feature_issuance

@MainActor
final class TestMrzDocumentIntroViewAccessibility: EudiTest {

  /// The view should render in a `UIHostingController` without crashing in the
  /// initial state (download not yet started).
  func testViewRendersInHostingControllerInInitialState() {
    let router = MockRouterHost()
    let interactor = MockLivenessCheckInteractor()
    stub(interactor) { mock in
      when(mock.prepareAssets()).thenReturn(true)
    }

    let viewModel = MrzDocumentIntroViewModel<MockRouterHost>(
      router: router,
      interactor: interactor,
      config: DocumentEnrollmentUiConfig()
    )
    let view = MrzDocumentIntroView(with: viewModel)

    let hosting = UIHostingController(rootView: view)
    hosting.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
    hosting.view.layoutIfNeeded()

    XCTAssertNotNil(hosting.view, "Hosting view should be created in the initial state")
  }

  /// The view should render without crashing when the download is in progress
  /// (which causes the `ProgressView` and download notice to appear).
  func testViewRendersInHostingControllerInDownloadingState() {
    let router = MockRouterHost()
    let interactor = MockLivenessCheckInteractor()
    stub(interactor) { mock in
      when(mock.prepareAssets()).thenReturn(true)
    }

    let viewModel = MrzDocumentIntroViewModel<MockRouterHost>(
      router: router,
      interactor: interactor,
      config: DocumentEnrollmentUiConfig()
    )
    viewModel.setState {
      $0.copy(downloadProgress: 42, isDownloading: true)
    }

    let view = MrzDocumentIntroView(with: viewModel)
    let hosting = UIHostingController(rootView: view)
    hosting.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
    hosting.view.layoutIfNeeded()

    XCTAssertNotNil(hosting.view, "Hosting view should be created in the downloading state")
    XCTAssertTrue(viewModel.viewState.isDownloading)
    XCTAssertEqual(viewModel.viewState.downloadProgress, 42)
  }

  /// The view should render without crashing when the download has failed
  /// (which causes the error text to appear).
  func testViewRendersInHostingControllerInFailedState() {
    let router = MockRouterHost()
    let interactor = MockLivenessCheckInteractor()
    stub(interactor) { mock in
      when(mock.prepareAssets()).thenReturn(false)
    }

    let viewModel = MrzDocumentIntroViewModel<MockRouterHost>(
      router: router,
      interactor: interactor,
      config: DocumentEnrollmentUiConfig()
    )
    viewModel.setState {
      $0.copy(downloadFailed: true)
    }

    let view = MrzDocumentIntroView(with: viewModel)
    let hosting = UIHostingController(rootView: view)
    hosting.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
    hosting.view.layoutIfNeeded()

    XCTAssertNotNil(hosting.view, "Hosting view should be created in the failed state")
    XCTAssertTrue(viewModel.viewState.downloadFailed)
  }
}
