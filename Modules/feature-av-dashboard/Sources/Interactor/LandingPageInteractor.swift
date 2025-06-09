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
        
        let documents = walletController.fetchIssuedDocuments(with: [.avAgeOver18])
        
        guard let documentDetails = documents.first?.transformToLandingUi() else {
          return .failure(WalletCoreError.unableFetchDocument)
        }
        return .success(documentDetails)
    }
}

public enum AgeCredentialPartialState: Sendable {
  case success(LandingViewUiModel)
  case failure(Error)
}
