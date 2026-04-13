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
    let isLoading: Bool
    let error: ContentErrorView.Config?
    let credRemainingCount: Int?
    let verifiedAge: Int?
}

final class LandingViewModel<Router: RouterHost>: ViewModel<Router, AppLandingState> {
    private let deepLinkController: DeepLinkController

    private let interactor: LandingInteractor
    init(router: Router, interactor: LandingInteractor, deepLinkController: DeepLinkController) {
        self.interactor = interactor
        self.deepLinkController = deepLinkController
        super.init(router: router,
                   initialState: .init(document: DocumentUIModel.mock(),
                                       isLoading: true,
                                       error: nil,
                                       credRemainingCount: nil,
                                       verifiedAge: nil
                                      )
        )
    }
    func onScan() {
        router.push(with: .featureCommonModule(.qrScanner(config: ScannerUiConfig(flow: .presentation))))
    }

    func onSettings() {
        router.push(with: .featureAVDashboardModule(.settings))
    }

    func getCredentialDetails() async {
        self.setState {
            $0.copy(isLoading: true)
        }
        let state = await Task.detached { () -> AgeCredentialPartialState in
            return await self.interactor.getAgeCredential()
        }.value

        switch state {
        case .success(let document, let credRemainingCount, let verifiedAge):
          self.setState {
            $0.copy(
              document: document,
              isLoading: false,
              credRemainingCount: credRemainingCount,
              verifiedAge: verifiedAge
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

    func refreshCredentials() async {
        await interactor.reloadDocuments()
        await getCredentialDetails()
    }

  func getMoreCredentials() {
    if viewState.credRemainingCount ?? -1 < 1 {
        router.push(
          with: .featureIssuanceModule(
            .issuanceAddDocument(
              config: IssuanceFlowUiConfig(flow: .extraDocument(filterType: .mDocPid))
            )
          )
        )
    }
  }

  func onCreate() async {
    await refreshCredentials()
    await handleDeepLink()
  }
  private func handleDeepLink() async {
    if let deepLink = deepLinkController.getPendingDeepLinkAction() {
      deepLinkController.handleDeepLinkAction(
        routerHost: router,
        deepLinkExecutable: deepLink,
        remoteSessionCoordinator: deepLink.requiresCoordinator
        ? await interactor.getWalletKitController().startSameDevicePresentation(deepLink: deepLink.link)
        : nil
      )
    }
  }
}
