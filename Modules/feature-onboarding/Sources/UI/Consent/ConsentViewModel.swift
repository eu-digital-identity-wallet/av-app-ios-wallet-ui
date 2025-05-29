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
    let termsOfServiceAccepted: Bool
    let dataProtectionInfoAccepted: Bool
    let nextButtonEnabled: Bool
}

final class ConsentViewModel<Router: RouterHost>: ViewModel<Router, ConsentViewState> {
    init(router: Router) {
        super.init(router: router,
                   initialState: .init(title: .completed,
                                       uiModel: ConsentViewUiModel.mock(),
                                       isLoading: true,
                                       error: nil,
                                       termsOfServiceAccepted: false,
                                       dataProtectionInfoAccepted: false,
                                       nextButtonEnabled: false
                                      )
        )
    }
    func onNext() {
        router.push(with: .featureOnboardingModule(.enrollment))
    }
    func onTermsOfServiceChanged(ischecked: Bool) {
        setState {
            $0.copy(
                termsOfServiceAccepted: ischecked
            )
        }
        updateNextButtonState()
    }
    func onDataProtectionInfoChanged(isChecked: Bool) {
        setState {
            $0.copy(
                dataProtectionInfoAccepted: isChecked
            )
        }
        updateNextButtonState()
    }
    private func updateNextButtonState() {
        let newState = viewState.termsOfServiceAccepted && viewState.dataProtectionInfoAccepted
        setState {
            $0.copy(
                nextButtonEnabled: newState
            )
        }
    }
}
