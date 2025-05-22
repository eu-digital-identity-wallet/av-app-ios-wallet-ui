//
//  ConsentViewModel.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 22/05/25.
//

import logic_ui
import logic_resources
import feature_common

@Copyable
struct ConsentViewState: ViewState {
    let title: LocalizableStringKey
    let uiModel: ConsentViewUiModel?
    let isLoading: Bool
    let error: ContentErrorView.Config?
}

final class ConsentViewModel<Router: RouterHost>: ViewModel<Router, ConsentViewState> {
    init(router: Router) {
        super.init(router: router,
                   initialState: .init(title: .completed,
                                       uiModel: ConsentViewUiModel.mock(),
                                       isLoading: true,
                                       error: nil
                                      )
        )
    }
}
