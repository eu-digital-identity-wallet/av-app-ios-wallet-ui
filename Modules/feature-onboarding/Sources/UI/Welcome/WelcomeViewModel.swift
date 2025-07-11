//
//  OnboardingHomeViewModel.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 21/05/25.
//

import logic_ui
import logic_resources
import feature_common

@Copyable
struct WelcomeViewState: ViewState {
    let isLoading: Bool
    let error: ContentErrorView.Config?
}

final class WelcomeViewModel<Router: RouterHost>: ViewModel<Router, WelcomeViewState> {
    init(router: Router) {
        super.init(router: router,
                   initialState: .init(
                                       isLoading: true,
                                       error: nil
                                      )
        )
    }

    func onNext() {
        router.push(with: .featureOnboardingModule(.consent))
    }
}
