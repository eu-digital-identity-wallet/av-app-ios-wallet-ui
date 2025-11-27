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
    let isLoading: Bool
    let error: ContentErrorView.Config?
    let termsOfServiceAccepted: Bool
    let dataProtectionInfoAccepted: Bool
    let dataProcessingInfoAccepted: Bool
    let nextButtonEnabled: Bool
}

final class ConsentViewModel<Router: RouterHost>: ViewModel<Router, ConsentViewState> {
    init(router: Router) {
        super.init(router: router,
                   initialState: .init(
                                       isLoading: true,
                                       error: nil,
                                       termsOfServiceAccepted: false,
                                       dataProtectionInfoAccepted: false,
                                       dataProcessingInfoAccepted: false,
                                       nextButtonEnabled: false
                                      )
        )
    }
    func onNext() {
        router.push(with: .featureCommonModule(.quickPin(config: QuickPinUiConfig(flow: .set))))
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
    func onDataProcessingInfoChanged(isChecked: Bool) {
        setState {
            $0.copy(
                dataProcessingInfoAccepted: isChecked
            )
        }
        updateNextButtonState()
    }
    private func updateNextButtonState() {
        let newState = viewState.termsOfServiceAccepted && viewState.dataProtectionInfoAccepted && viewState.dataProcessingInfoAccepted
        setState {
            $0.copy(
                nextButtonEnabled: newState
            )
        }
    }
}
