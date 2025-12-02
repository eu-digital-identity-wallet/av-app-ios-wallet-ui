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
        return .success(documentDetails, credentialCount)
    }

    func getWalletKitController() -> WalletKitController {
      self.walletController
    }
}

public enum AgeCredentialPartialState: Sendable {
  case success(DocumentUIModel, Int?)
  case failure(Error)
}
