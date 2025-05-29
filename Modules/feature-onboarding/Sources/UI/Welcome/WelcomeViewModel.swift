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
    let title: LocalizableStringKey
    let uiModel: WelcomeViewUiModel?
    let isLoading: Bool
    let error: ContentErrorView.Config?
}

final class WelcomeViewModel<Router: RouterHost>: ViewModel<Router, WelcomeViewState> {
    init(router: Router) {
        super.init(router: router,
                   initialState: .init(title: .completed,
                                       uiModel: WelcomeViewUiModel.mock(),
                                       isLoading: true,
                                       error: nil
                                      )
        )
    }

    func onNext() {
        router.push(with: .featureOnboardingModule(.consent), animated: false)
    }
}
