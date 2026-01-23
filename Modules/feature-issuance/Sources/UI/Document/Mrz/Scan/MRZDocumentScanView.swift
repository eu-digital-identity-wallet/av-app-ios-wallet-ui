/*
 * Copyright (c) 2025 European Commission
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

import SwiftUI
import logic_ui
import logic_resources
import mrz_reader

struct MRZDocumentScanView<Router: RouterHost>: View {
  @State private var viewModel: MRZDocumentScanViewModel<Router>

  #if DEBUG
  private let loggingEnabled = true
  #else
  private let loggingEnabled = false
  #endif

  init(with viewModel: MRZDocumentScanViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ZStack {
      if let errorConfig = viewModel.viewState.error {
        ContentErrorView(config: errorConfig)
      } else {
        ZStack {
          DocumentScannerView(
            configuration: MRZReaderConfiguration(
              loggingEnabled: loggingEnabled,
              strings: .init(
                documentReady: LocalizableStringKey.mrzDocumentReady.toString,
                scanning: LocalizableStringKey.mrzScanning.toString,
                placeDocumentInFrame: LocalizableStringKey.passportCaptureSubtitle.toString,
                cameraError: LocalizableStringKey.mrzCameraError.toString,
                cameraPermissionDenied: LocalizableStringKey.mrzCameraPermissionDenied.toString,
                cameraSetupFailed: LocalizableStringKey.mrzCameraSetupFailed.toString,
                unknownError: LocalizableStringKey.mrzUnknownError.toString,
                initializingCamera: LocalizableStringKey.mrzInitializingCamera.toString
              )
            ),
            onMRZCaptured: { mrzData in
              viewModel.onMRZScanned(mrzData: mrzData)
            }
          )
          .ignoresSafeArea()

          // Processing overlay
          if viewModel.viewState.isProcessing {
            Color.black.opacity(0.5)
              .ignoresSafeArea()
            VStack(spacing: 16) {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
              Text(LocalizableStringKey.nfcBodyReading.toString)
                .foregroundColor(.white)
                .font(.headline)
            }
          }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
              viewModel.backButtonTapped()
            }) {
              Image(systemName: "chevron.left")
                .foregroundColor(.white)
            }
          }
        }
      }
    }
  }
}
