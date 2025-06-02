//
//  AppLandingViewModel.swift
//  feature-av-dashboard
//
//  Created by A200156428 on 30/05/25.
//

import logic_ui
import logic_resources
import feature_common

@Copyable
struct AppLandingState: ViewState {
    let title: LocalizableStringKey
    let isLoading: Bool
    let error: ContentErrorView.Config?
}

final class AppLandingViewModel<Router: RouterHost>: ViewModel<Router, AppLandingState> {
    init(router: Router) {
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
}
