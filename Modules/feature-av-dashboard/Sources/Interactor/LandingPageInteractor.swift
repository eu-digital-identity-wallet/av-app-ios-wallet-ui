//
//  CredentialDetailsInteractor.swift
//  feature-av-dashboard
//
//  Created by A200156428 on 04/06/25.
//

import logic_core
import feature_common

public protocol LandingPageInteractor: Sendable {
    
    func getAgeCredential() async -> AgeCredentialPartialState  
}

final class LandingPageInteractorImpl: LandingPageInteractor {
    
    private let walletController: WalletKitController

    public init(
      walletController: WalletKitController
    ) {
      self.walletController = walletController
    }
    
    func getAgeCredential() async -> AgeCredentialPartialState {
        
        let documents = walletController.fetchIssuedDocuments(with: [.avAgeOver18,.mdocEUDIAgeOver18])
        guard let documentDetails = documents.first?.transformToDocumentUi() else {
          return .failure(WalletCoreError.unableFetchDocument)
        }
        let credentialCount = await getCredentialsUsageCount(documentId: documentDetails.id)
        return .success(documentDetails, credentialCount)
    }
    
    private func getCredentialsUsageCount(documentId: String) async -> Int? {
      do {
        if let usageCounts = try await walletController.getCredentialsUsageCount(id: documentId) {
          return usageCounts.remaining
        } else {
          return nil
        }
      } catch {
        return nil
      }
    }
}

public enum AgeCredentialPartialState: Sendable {
  case success(DocumentUIModel, Int?)
  case failure(Error)
}
