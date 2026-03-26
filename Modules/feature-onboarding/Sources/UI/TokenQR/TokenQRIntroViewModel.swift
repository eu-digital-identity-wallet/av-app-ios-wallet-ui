//
//  TokenQRIntroViewModel.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 26/03/26.
//

import logic_ui
import logic_resources
import feature_common

@Copyable
struct TokenQrIntroState: ViewState {
}

final class TokenQrIntroViewModel<Router: RouterHost>: ViewModel<Router, TokenQrIntroState> {
  init(router: Router) {
    super.init(router: router,
               initialState: .init()
    )
  }
  func onBack() {
    router.pop()
  }

  func onScan() {
    router.push(
      with: .featureCommonModule(
        .qrScanner(config: ScannerUiConfig(
          flow: .issuing(
            successNavigation: .push(AppRoute.featureAVDashboardModule(.appLanding)),
            cancelNavigation: .popTo(AppRoute.featureIssuanceModule(.issuanceAddDocument(config: IssuanceFlowUiConfig(flow: .noDocument))))
          )
        ))
      )
    )
  }
}
