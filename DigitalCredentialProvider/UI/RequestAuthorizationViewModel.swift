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

import IdentityDocumentServices
import IdentityDocumentServicesUI
import MdocDataModel18013
import WalletStorage
import SwiftUI
import DcApi18013AnnexC
import LongfellowZkp
import Combine

@MainActor
class RequestAuthorizationViewModel: ObservableObject {
  // MARK: - Published Properties
  @Published var websiteName: String?
  @Published var requestSet: ISO18013MobileDocumentRequest.DocumentRequestSet?
  @Published var errorMessage: String?

  // MARK: - Dependencies
  private let dcApiHandler: DcApiHandler
  private let context: ISO18013MobileDocumentRequestContext?
  private var dcApiResponseData: Data?

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

      let (_, set, _, rn) = try await dcApiHandler.validateRequest(context.request)
      requestSet = set
      websiteName = context.requestingWebsiteOrigin?.absoluteString ?? rn ?? "Website name not available"

    } catch {
      errorMessage = String(describing: error)
    }
  }

  func acceptVerification() async {
    guard let context else {
      errorMessage = "Context is not available"
      return
    }

    do {
      try await context.sendResponse { rawRequest in
        try await self.dcApiHandler.validateConsistency(request: context.request, rawRequest: rawRequest)
        return try await self.sendResponse(rawRequest, context.requestingWebsiteOrigin?.absoluteString)
      }
    } catch {
      errorMessage = String(describing: error)
    }
  }

  func cancelRequest() {
    context?.cancel()
  }

  func extractAge(from key: String) -> Int? {
      key.split(separator: "_").last.flatMap { Int($0) }
  }

  // MARK: - Helper Methods
  func sendResponse(_ rawRequest: IdentityDocumentWebPresentmentRawRequest, _ originUrl: String?) async throws -> ISO18013MobileDocumentResponse {
    dcApiResponseData = nil
    var zkSystemRepository: ZkSystemRepository?
    let systemVersion = UIDevice.current.systemVersion
    let isIOS26 = systemVersion.hasPrefix("26")
    
    if isIOS26 {
      // iOS 26 has extension memory limit, compute zk proof from iOS (work around)
      // Delegate ZKP computation to the main app via shared storage and silent push
      // see ZKP Proof Calculation via Silent Push section above
    } else {
      // iOS 27+ has enough memory, compute in ZK Proof directly in extension
      zkSystemRepository = Self.makeZkSystemRepository()
    }
    
    let responseData = try await dcApiHandler.buildAndEncryptResponse(
      rawRequest: rawRequest,
      originUrl: originUrl,
      zkSystemRepository: zkSystemRepository
    )
    
    return ISO18013MobileDocumentResponse(responseData: responseData)
  }

  static func makeZkSystemRepository() -> ZkSystemRepository {
    let circuits = LongfellowZkSystem.enumerateLongfellowCircuits()
    return ZkSystemRepository(systems: [LongfellowZkSystem(circuits: circuits)])
  }
}
