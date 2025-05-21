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
struct OnboardingHomeViewState: ViewState {
    let title: LocalizableStringKey
    let onboardingHomeUi: OnboardingHomeUiModel?
    let isLoading: Bool
    let error: ContentErrorView.Config?
}

final class OnboardingHomeViewModel<Router: RouterHost>: ViewModel<Router, OnboardingHomeViewState> {
    init(router: Router) {
        super.init(router: router,
                   initialState: .init(title: .completed,
                                       onboardingHomeUi: OnboardingHomeUiModel.mock(),
                                       isLoading: true,
                                       error: nil
                                      )
        )
    }
}
