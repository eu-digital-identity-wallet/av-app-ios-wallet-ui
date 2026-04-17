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
import IdentityDocumentServices
import IdentityDocumentServicesUI
import MdocDataModel18013
import WalletStorage
import DcApi18013AnnexC
import feature_common

struct RequestAuthorizationView: View {

  @StateObject private var viewModel: RequestAuthorizationViewModel
  var routerHost: RouterHost

  init(context: ISO18013MobileDocumentRequestContext? = nil,
       dcApiHandler: DcApiHandler,
       routerHost: RouterHost) {
    _viewModel = StateObject(wrappedValue: RequestAuthorizationViewModel(
      context: context,
      dcApiHandler: dcApiHandler
    ))
    self.routerHost = routerHost
  }

  var body: some View {
    VStack(alignment: .center) {
      if let requestSet = viewModel.requestSet,
         let websiteName = viewModel.websiteName {
        contentView(requestSet: requestSet, websiteName: websiteName)
      } else {
        ContentUnavailableView(
          "Cannot validate request",
          image: "externaldrive.fill.trianglebadge.exclamationmark"
        )
      }
    }
    .frame(maxWidth: .infinity)
    .padding()
    .task {
      await viewModel.loadRequest()
    }
  }

  // MARK: - Subviews
  @ViewBuilder
  private func contentView(requestSet: ISO18013MobileDocumentRequest.DocumentRequestSet,
                           websiteName: String) -> some View {
    VStack(alignment: .center) {
      if let requestSet = viewModel.requestSet,
         let websiteName = viewModel.websiteName {
        Text(websiteName).font(.headline).padding(.bottom, 6)

        List {
          HStack(alignment: .center) {
            ThemeManager.shared.image.logoEuDigitalIndentityWallet
              .resizable()
              .scaledToFit()
              .frame(width: 60, height: 60)
          }
          .frame(maxWidth: .infinity, alignment: .center)
          VStack(alignment: .leading, spacing: 12) {
            ForEach(requestSet.requests, id: \.documentType) { rs in
              VStack(alignment: .leading, spacing: 4) {
                Text(.passportScanIntroStep5Title)
                  .font(.headline)
                  .foregroundColor(.primary)

                Text(.splashScreenTitle)
                  .font(.subheadline)
                  .foregroundColor(.secondary)
              }
              // Section Header
              Text(.documentProviderSectionHeader)
                .font(.subheadline)
                .foregroundColor(.primary)

              // Bullet Point
              let namespaces = Array(rs.namespaces.keys)
              ForEach(namespaces, id: \.self) { ns in
                let elements = Array(rs.namespaces[ns]!.keys)
                ForEach(elements, id: \.self) { el in
                  HStack(alignment: .top, spacing: 8) {
                    Text("•")
                    if let age = viewModel.extractAge(from: el) {
                        Text(LocalizableStringKey.ageOver(age).toString)
                      .fontWeight(rs.namespaces[ns]![el]!.isRetaining ? .bold : .thin)
                    }
                  }
                }
              }
            }
          }
        }
        .frame(maxWidth: .infinity)
        actionButtons()
      } else {
        ContentUnavailableView("Cannot validate request",
                               image: "externaldrive.fill.trianglebadge.exclamationmark")
      }
    }
    .frame(maxWidth: .infinity)
    .padding() // vstack
  }

  @ViewBuilder
  private func actionButtons() -> some View {
    VStack(alignment: .center, spacing: 10) {
      if viewModel.errorMessage == nil {
        acceptButton()
      }

      cancelButton()
    }
    .frame(maxWidth: .infinity)
  }

  @ViewBuilder
  private func acceptButton() -> some View {
    Button(.genericAccept) {
      let config = viewModel.createBiometryConfig(routerHost: routerHost)
      routerHost.push(with: .featureIDPModule(.biometry(config: config)))
    }
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .padding(.vertical, 8)
  }

  @ViewBuilder
  private func cancelButton() -> some View {
    Button(.genericClose) {
      viewModel.cancelRequest()
    }
    .buttonStyle(.bordered)
    .controlSize(.large)
    .padding(.vertical, 8)
  }
}
