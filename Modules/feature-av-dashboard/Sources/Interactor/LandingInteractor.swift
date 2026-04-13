//
//  CredentialDetailsInteractor.swift
//  feature-av-dashboard
//
//  Created by A200156428 on 04/06/25.
//

import logic_core
import feature_common

public protocol LandingInteractor: Sendable {

    func getAgeCredential() async -> AgeCredentialPartialState
    func reloadDocuments() async
    func getWalletKitController() -> WalletKitController
}

final class LandingPageInteractorImpl: LandingInteractor {

    private let walletController: WalletKitController

    public init(
      walletController: WalletKitController
    ) {
      self.walletController = walletController
    }

    func getAgeCredential() async -> AgeCredentialPartialState {
        let documents = await walletController.fetchIssuedDocuments(with: [.avAgeOver18, .mdocEUDIAgeOver18])
        guard let document = documents.first else {
            return .failure(WalletCoreError.unableFetchDocument)
        }
        let documentDetails = document.transformToDocumentUi(isSensitive: false)
        let credentialCount = document.credentialsUsageCounts?.remaining
        let verifiedAge = Self.extractVerifiedAge(from: document)
        return .success(documentDetails, credentialCount, verifiedAge)
    }

    private static func extractVerifiedAge(from document: DocClaimsDecodable) -> Int? {
        let fromDict = document.ageOverXX.filter({ $0.value }).keys

        let ageOverPrefix = "age_over_"
        let fromClaims = document.docClaims
            .filter { $0.name.hasPrefix(ageOverPrefix) && $0.stringValue.lowercased() == "true" }
            .compactMap { Int($0.name.dropFirst(ageOverPrefix.count)) }

        let allAges = Array(fromDict) + fromClaims
        return allAges.max()
    }

    func getWalletKitController() -> WalletKitController {
      self.walletController
    }

    func reloadDocuments() async {
      try? await walletController.loadDocuments()
    }
}

public enum AgeCredentialPartialState: Sendable {
  case success(DocumentUIModel, Int?, Int?)
  case failure(Error)
}
