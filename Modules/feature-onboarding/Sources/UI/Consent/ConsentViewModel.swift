//
//  ConsentViewModel.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 22/05/25.
//

import logic_ui
import logic_resources
import feature_common
import Foundation

@Copyable
struct ConsentViewState: ViewState {
    let title: LocalizableStringKey
    let uiModel: ConsentViewUiModel?
    let isLoading: Bool
    let error: ContentErrorView.Config?
    var checkbox1Checked: Bool
    var checkbox2Checked: Bool
}

final class ConsentViewModel<Router: RouterHost>: ViewModel<Router, ConsentViewState> {
    init(router: Router) {
        super.init(router: router,
                   initialState: .init(title: .completed,
                                       uiModel: ConsentViewUiModel.mock(),
                                       isLoading: true,
                                       error: nil,
                                       checkbox1Checked: false,
                                       checkbox2Checked: false,
                                      )
        )
    }
    func onNext() {
        router.push(with: .featureOnboardingModule(.enrollment))
    }
}
