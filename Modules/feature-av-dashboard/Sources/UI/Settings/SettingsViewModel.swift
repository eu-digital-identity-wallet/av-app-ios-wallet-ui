//
//  SettingsViewModel.swift
//  feature-av-dashboard
//
//  Created by A200301424 on 07/07/25.
//

import logic_resources
import feature_common
import logic_core

@Copyable
struct SettingsState: ViewState {
  let isLoading: Bool
  let error: ContentErrorView.Config?
  let appVersion: String
  let isDeletingCredentials: Bool
}

final class SettingsViewModel<Router: RouterHost>: ViewModel<Router, SettingsState> {
  
  @Published var isDeletionModalShowing: Bool = false
  
  private let interactor: SettingsInteractor
  
  init(router: Router, interactor: SettingsInteractor) {
    self.interactor = interactor
    super.init(router: router,
               initialState: .init(
                                   isLoading: false,
                                   error: nil,
                                   appVersion: interactor.getAppVersion(),
                                   isDeletingCredentials: false
                                  )
    )
  }
  
  func navigateBack() {
    router.pop()
  }
  
  func onShowDeleteModal() {
    isDeletionModalShowing = !isDeletionModalShowing
  }
  
  func onDeleteCredentials() {
    isDeletionModalShowing = false
    Task {
      self.setState { $0.copy(isDeletingCredentials: true).copy(error: nil) }
      
      let result = await Task.detached { () -> Result<Void, Error> in
        return await self.interactor.deleteAgeVerificationCredentials()
      }.value
      
      switch result {
      case .success:
        self.setState {
          $0.copy(isDeletingCredentials: false)
        }
        self.router.push(
          with: .featureIssuanceModule(
            .issuanceAddDocument(
              config: IssuanceFlowUiConfig(flow: .noDocument)
            )
          )
        )
      case .failure(let error):
        self.setState {
          $0.copy(
            error: .init(
              description: .custom(error.localizedDescription),
              cancelAction: self.setState { $0.copy(error: nil) }
            ),
            isDeletingCredentials: false
          )
        }
      }
    }
  }
}
