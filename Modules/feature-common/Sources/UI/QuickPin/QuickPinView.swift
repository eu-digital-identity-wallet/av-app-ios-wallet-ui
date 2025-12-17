/*
 * Copyright (c) 2025 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */
import SwiftUI
import logic_ui
import logic_resources

struct QuickPinView<Router: RouterHost>: View {

  @State private var viewModel: QuickPinViewModel<Router>

  init(with viewModel: QuickPinViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      navigationTitle: nil,
      toolbarContent: viewModel.viewState.step == .firstInput ? nil : viewModel.toolbarContent()
    ) {
      content(
        viewState: viewModel.viewState,
        uiPinInputField: $viewModel.uiPinInputField,
        onShowCancellationModal: { viewModel.onShowCancellationModal() },
        onButtonClick: { viewModel.onButtonClick() }
      )
    }
    .dialogCompat(
      .quickPinBottomSheetCancelTitle,
      isPresented: $viewModel.isCancelModalShowing,
      actions: {
        Button(.quickPinBottomSheetCancelSecondaryButtonText, role: .destructive) {
          viewModel.onPop()
        }
        Button(.quickPinBottomSheetCancelPrimaryButtonText, role: .cancel) {
          viewModel.onShowCancellationModal()
        }
      },
      message: {
        Text(.quickPinBottomSheetCancelSubtitle)
      }
    )
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: QuickPinState,
  uiPinInputField: Binding<String>,
  onShowCancellationModal: @escaping () -> Void,
  onButtonClick: @escaping () -> Void
) -> some View {
    ScrollView {
      OnboardingTabsView(steps: Onboardingsteps.allCases,
                           selectedIndex: 2)
        VStack(alignment: .leading, spacing: .zero) {
            VSpacer.small()
            Text(viewState.step == QuickPinStep.firstInput ? LocalizableStringKey.quickPinCreateTitle.toString : LocalizableStringKey.quickPinCreateReenterTitle.toString)
                .typography(Theme.shared.font.titleMedium)
            VSpacer.small()
            pinView(
                subtitleText: viewState.step == .firstInput ? LocalizableStringKey.quickPinCreateEnterSubtitle.toString : LocalizableStringKey.quickPinCreateReenterSubtitle.toString,
                uiPinInputField: uiPinInputField,
                quickPinSize: viewState.quickPinSize,
                pinError: viewState.pinError
            )
            Spacer()
        }
        .padding(.horizontal, Theme.shared.dimension.padding)
    }
}

@MainActor
@ViewBuilder
private func pinView(
  subtitleText: String,
  uiPinInputField: Binding<String>,
  quickPinSize: Int,
  pinError: LocalizableStringKey?
) -> some View {
    Group {
    Text(subtitleText)
        .typography(Theme.shared.font.bodySmall)
        .foregroundColor(Theme.shared.color.grey)
        .padding(.bottom, SPACING_EXTRA_SMALL)

    PinTextFieldView(
      numericText: uiPinInputField,
      maxDigits: quickPinSize,
      isSecureEntry: true,
      canFocus: .constant(true),
      shouldUseFullScreen: true,
      hasError: pinError != nil
    )

    VSpacer.mediumSmall()

    if let error = pinError {
      HStack {
        Text(error)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundColor(Theme.shared.color.error)
        Spacer()
      }
    }
  }
}

#Preview {
  let viewState = QuickPinState(
    config: QuickPinUiConfig(flow: .set),
    navigationTitle: .quickPinCreateTitle,
    title: .quickPinCreateTitle,
    caption: .quickPinCreateEnterSubtitle,
    button: .quickPinNextButton,
    success: .genericSuccess,
    successButton: .quickPinChangeSuccessBtn,
    successNavigationType: .push(screen: .featureAVDashboardModule(.appLanding)),
    isCancellable: false,
    pinError: nil,
    isButtonActive: true,
    step: .firstInput,
    quickPinSize: 6
  )

  ContentScreenView {
    content(
      viewState: viewState,
      uiPinInputField: .constant("PinInput Field"),
      onShowCancellationModal: {},
      onButtonClick: {}
    )
  }
}
