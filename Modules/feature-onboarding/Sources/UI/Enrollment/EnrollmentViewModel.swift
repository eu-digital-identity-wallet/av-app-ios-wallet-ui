//
//  EnrollmentViewModel.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 22/05/25.
//

import logic_ui
import logic_resources
import feature_common

@Copyable
struct EnrollmentViewState: ViewState {
    let title: LocalizableStringKey
    let uiModel: EnrollmentViewUiModel?
    let isLoading: Bool
    let error: ContentErrorView.Config?
}

final class EnrollmentViewModel<Router: RouterHost>: ViewModel<Router, EnrollmentViewState> {
    init(router: Router) {
        super.init(router: router,
                   initialState: .init(title: .completed,
                                       uiModel: EnrollmentViewUiModel.mock(),
                                       isLoading: true,
                                       error: nil
                                      )
        )
    }
}
