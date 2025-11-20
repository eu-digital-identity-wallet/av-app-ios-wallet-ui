import IdentityDocumentServices
import IdentityDocumentServicesUI
import MdocDataModel18013
import WalletStorage
import SwiftUI
import DcApi18013AnnexC

struct RequestAuthorizationView: View {
  let context: ISO18013MobileDocumentRequestContext
  let dcApiHandler: DcApiHandler
  @State var websiteName: String?
  @State var requestSet: ISO18013MobileDocumentRequest.DocumentRequestSet?
  @State var errorMessage: String?

  var body: some View {
    VStack(alignment: .center) {
      if let requestSet, let websiteName {
        Text(websiteName).font(.headline).padding(.bottom, 6)
        List {
          VStack(alignment: .leading, spacing: 12) {
            ForEach(requestSet.requests, id: \.documentType) { rs in
              VStack(alignment: .leading, spacing: 4) {
                Text("Proof of Age")
                  .font(.headline)
                  .foregroundColor(.primary)

                Text("Age Verification")
                  .font(.subheadline)
                  .foregroundColor(.secondary)
              }
              // Section Header
              Text("This information will be shared:")
                .font(.subheadline)
                .foregroundColor(.primary)

              // Bullet Point
              let namespaces = Array(rs.namespaces.keys)
              ForEach(namespaces, id: \.self) { ns in
                let elements = Array(rs.namespaces[ns]!.keys)
                ForEach(elements, id: \.self) { el in
                  HStack(alignment: .top, spacing: 8) {
                    Text("•")
                    Text(el).fontWeight(
                      rs.namespaces[ns]![el]!.isRetaining ? .bold : .thin)
                  }
                }
              }
            }
          }
        }
        .frame(maxWidth: .infinity)
        if let errorMessage { Text(verbatim: errorMessage).foregroundStyle(.red) }
        VStack(alignment: .center, spacing: 10) {
          if errorMessage == nil {
            Button("Accept") {
              Task { try await self.acceptVerification() }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.vertical, 8)
          }
          Button("Cancel") {
            context.cancel()
          }
          .buttonStyle(.bordered)
          .controlSize(.large)
          .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity)
      } else {
        ContentUnavailableView("Cannot validate request",
        image: "externaldrive.fill.trianglebadge.exclamationmark")
      }
    }
    .frame(maxWidth: .infinity)
    .padding() // vstack
    .task {
      do {
        let (set, _, rn) = try await dcApiHandler.validateRequest(context.request)
        requestSet = set
        websiteName = context.requestingWebsiteOrigin?.absoluteString ?? rn ??
        "Website name not available"
      } catch {
        errorMessage = String(describing: error)
      }
    }
  } // body

  func acceptVerification() async throws {
    try await context.sendResponse { rawRequest in
      try await dcApiHandler.validateConsistency(request: context.request, rawRequest: rawRequest)
      // validate the signatures
      try await dcApiHandler.validateRawRequest(rawRequest: rawRequest)
      let responseData = try await dcApiHandler.buildAndEncryptResponse(
        request: context.request, rawRequest: rawRequest,
        originUrl: context.requestingWebsiteOrigin?.absoluteString)
      return ISO18013MobileDocumentResponse(responseData: responseData)
    }
  }
} // end view
