//
//  AppLandingViewModel.swift
//  feature-av-dashboard
//
//  Created by A200156428 on 30/05/25.
//

import logic_resources
import feature_common
import logic_core

@Copyable
struct AppLandingState: ViewState {
   // let document: LandingViewUiModel
    let title: LocalizableStringKey
    let isLoading: Bool
    let error: ContentErrorView.Config?
}

final class AppLandingViewModel<Router: RouterHost>: ViewModel<Router, AppLandingState> {
    
    private let interactor: LandingPageInteractor
    init(router: Router, interactor: LandingPageInteractor,) {
        self.interactor = interactor
        super.init(router: router,
                   initialState: .init(title: .completed,
                                       isLoading: true,
                                       error: nil
                                      )
        )
    }
    func onScan() {
        router.push(with: .featureCommonModule(.qrScanner(config: ScannerUiConfig(flow: .presentation))))
    }
    
    func getCredentialDetails() async {
        
//        let walletController: WalletKitController
//        let documents = walletController.fetchIssuedDocuments(with: [.avAgeOver18])
//        print(documents)
        let state = await Task.detached { () -> AgeCredentialPartialState in
            return await self.interactor.getAgeCredential()
        }.value
        
//        switch state {
//        }
    }

}
