import IdentityDocumentServices
import IdentityDocumentServicesUI
import MdocDataModel18013
import WalletStorage
import SwiftUI
import DcApi18013AnnexC
import feature_common

@MainActor
class RequestAuthorizationViewModel: ObservableObject {
  // MARK: - Published Properties
  @Published var websiteName: String?
  @Published var requestSet: ISO18013MobileDocumentRequest.DocumentRequestSet?
  @Published var errorMessage: String?

  // MARK: - Dependencies
  private let dcApiHandler: DcApiHandler
  private let context: ISO18013MobileDocumentRequestContext?

  // MARK: - Initialization
  init(context: ISO18013MobileDocumentRequestContext?,
       dcApiHandler: DcApiHandler) {
    self.context = context
    self.dcApiHandler = dcApiHandler
  }

  func loadRequest() async {
    do {
      guard let context else {
        errorMessage = "Context is not available"
        return
      }

      let (set, _, rn) = try await dcApiHandler.validateRequest(context.request)
      requestSet = set
      websiteName = context.requestingWebsiteOrigin?.absoluteString ?? rn ?? "Website name not available"

    } catch {
      errorMessage = String(describing: error)
    }
  }

  func acceptVerification() async throws {
    guard let context else {
      throw NSError(domain: "RequestAuthorizationViewModel",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Context is not available"])
    }

    try await context.sendResponse { rawRequest in
      try await self.dcApiHandler.validateConsistency(request: context.request, rawRequest: rawRequest)
      try await self.dcApiHandler.validateRawRequest(rawRequest: rawRequest)

      let responseData = try await self.dcApiHandler.buildAndEncryptResponse(
        request: context.request,
        rawRequest: rawRequest,
        originUrl: context.requestingWebsiteOrigin?.absoluteString
      )

      return ISO18013MobileDocumentResponse(responseData: responseData)
    }
  }

  func cancelRequest() {
    context?.cancel()
  }

  // MARK: - Helper Methods
  func createBiometryConfig(routerHost: RouterHost) -> UIConfig.Biometry {
    UIConfig.Biometry(
      navigationTitle: .custom(""),
      displayLogo: false,
      title: .custom(""),
      caption: .dataSharingTitle,
      quickPinOnlyCaption: .custom(""),
      navigationSuccessType: nil,
      navigationBackType: .pop,
      isPreAuthorization: true,
      shouldInitializeBiometricOnCreate: true,
      onAuthResult: { [weak self] result in
        guard let self = self else { return }

        switch result {
        case .success:
          Task {
            try await self.acceptVerification()
            await routerHost.pop()
          }
        case .cancelled, .error:
          break
        }
      }
    )
  }
}
