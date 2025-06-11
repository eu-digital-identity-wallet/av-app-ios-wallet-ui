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
    let document: DocumentUIModel
    let title: LocalizableStringKey
    let isLoading: Bool
    let error: ContentErrorView.Config?
    
}

final class AppLandingViewModel<Router: RouterHost>: ViewModel<Router, AppLandingState> {
    
    private let interactor: LandingPageInteractor
    init(router: Router, interactor: LandingPageInteractor,) {
        self.interactor = interactor
        super.init(router: router,
                   initialState: .init(document: DocumentUIModel.mock(), title: .completed,
                                       isLoading: true,
                                       error: nil
                                      )
        )
    }
    func onScan() {
        router.push(with: .featureCommonModule(.qrScanner(config: ScannerUiConfig(flow: .presentation))))
    }
    
    func getCredentialDetails() async {
        self.setState {
            $0.copy(isLoading: true)
        }
        let state = await Task.detached { () -> AgeCredentialPartialState in
            return await self.interactor.getAgeCredential()
        }.value
        
        switch state {
        case .success(let document):
          self.setState {
            $0.copy(
              document: document,
              isLoading: false,
            ).copy(error: nil)
          }
        case .failure(let error):
          self.setState {
            $0.copy(
              isLoading: false,
              error: .init(
                description: .custom(error.localizedDescription), cancelAction: (),
              )
            )
          }
        }
    }
}
