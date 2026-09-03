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

public struct BiometryView<Router: RouterHost>: View {

  @State private var viewModel: BiometryViewModel<Router>
  @Environment(\.scenePhase) var scenePhase
  @State private var keyboardHeight: CGFloat = 0

  public init(with viewModel: BiometryViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  public var body: some View {
    ContentScreenView(
      canScroll: true,
      navigationTitle: viewModel.viewState.config.navigationTitle,
      toolbarContent: viewModel.toolbarContent()
    ) {
      content(
        viewState: viewModel.viewState,
        subtitleText: LocalizableStringKey.quickPinChangeValidateCurrentSubtitle.toString,
        uiPinInputField: $viewModel.uiPinInputField,
        onBiometry: viewModel.onBiometry,
        keyboardHeight: keyboardHeight
      )
      .alert(item: $viewModel.biometryError) { error in
        Alert(
          title: Text(.genericErrorMessage),
          message: Text(error.errorDescription.orEmpty),
          primaryButton: .default(Text(.openSystemSettings)) {
            self.viewModel.onSettings()
          },
          secondaryButton: .cancel {}
        )
      }
      .onChange(of: scenePhase) {
        self.viewModel.setPhase(with: scenePhase)
      }
    }
    .task {
      await self.viewModel.onAppearBiometry()
    }
    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { notification in
      guard let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
        return
      }
      let screenHeight = UIApplication.shared.currentUIWindow?.bounds.height ?? 0
      keyboardHeight = (screenHeight > 0 && endFrame.minY >= screenHeight) ? 0 : max(0, endFrame.height)
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: BiometryState,
  subtitleText: String,
  uiPinInputField: Binding<String>,
  onBiometry: @escaping () -> Void,
  keyboardHeight: CGFloat
) -> some View {

  VStack {
    ScrollViewReader { proxy in
      ScrollView {
        if viewState.config.displayLogo {
          ContentHeaderView(
            config: viewState.contentHeaderConfig
          )
        }

        ContentTitleView(
          title: viewState.config.title,
          accessibilityTitle: BiometryLocators.biometryScreenTitle,
          titleWeight: .semibold,
          caption: viewState.areBiometricsEnabled
          ? viewState.config.caption
          : viewState.config.quickPinOnlyCaption,
          accessibilityCaption: BiometryLocators.biometryScreenPinText,
          titleColor: Theme.shared.color.onSurface,
          textAlignment: viewState.config.alignment,
          topSpacing: viewState.isCancellable ? .withToolbar : .withoutToolbar
        )

        VSpacer.large()

        pinView(
          subtitleText: subtitleText,
          uiPinInputField: uiPinInputField,
          quickPinSize: viewState.quickPinSize,
          areBiometricsEnabled: viewState.areBiometricsEnabled,
          pinError: viewState.pinError,
          disabled: viewState.isLockedOut
        )
        .id("pinField")
        .accessibilityAnnouncement(for: viewState.pinError, message: viewState.pinError)
          
        Spacer()

        if viewState.areBiometricsEnabled, let image = viewState.biometryImage {
          HStack {
            Spacer()
            image
              .onTapGesture {
                onBiometry()
              }
          }
          .padding(.horizontal)
        }
        Spacer()
      }
      .scrollDismissesKeyboard(.interactively)
      .safeAreaInset(edge: .bottom, spacing: 0) {
        Color.clear.frame(height: keyboardHeight)
      }
      .onChange(of: keyboardHeight) { _, newValue in
        guard newValue > 0 else { return }
        withAnimation {
          proxy.scrollTo("pinField", anchor: .center)
        }
      }
      .frame(maxWidth: . infinity)
    }
  }
}

@MainActor
@ViewBuilder
private func pinView(
  subtitleText: String,
  uiPinInputField: Binding<String>,
  quickPinSize: Int,
  areBiometricsEnabled: Bool,
  pinError: String?,
  disabled: Bool
) -> some View {
    VStack(alignment: .leading, spacing: .zero) {
    VSpacer.extraSmall()

    Text(subtitleText)
        .typography(Theme.shared.font.bodyMedium)
        .foregroundColor(Theme.shared.color.lightText)
        .padding(.bottom, SPACING_EXTRA_SMALL)

    PinTextFieldView(
      numericText: uiPinInputField,
      maxDigits: quickPinSize,
      isSecureEntry: true,
      canFocus: .constant(true), // temp change, keyboard is not getting focus in iOS 27
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
  let viewState = BiometryState(
    config: UIConfig.Biometry(
      navigationTitle: .custom("Navigation Title"),
      title: .biometricDefaultModeTextAbovePinField,
      caption: .biometricLoginBiometricsNotEnabledSubtitle,
      quickPinOnlyCaption: .quickPinCreateEnterSubtitle,
      navigationSuccessType: .pop,
      navigationBackType: nil,
      isPreAuthorization: true,
      shouldInitializeBiometricOnCreate: true
    ),
    areBiometricsEnabled: true,
    pinError: nil,
    throttlePinInput: true,
    scenePhase: .active,
    pendingNavigation: nil,
    autoBiometryInitiated: true,
    biometryImage: Theme.shared.image.faceId,
    isCancellable: true,
    quickPinSize: 6,
    lockoutEndTime: 0,
    contentHeaderConfig: .init(
      appIconAndTextData: AppIconAndTextData(
        appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
        appText: ThemeManager.shared.image.euditext
      )
    ),
    isLockoutStatusChecked: true
  )

  ContentScreenView {
    content(
      viewState: viewState,
      subtitleText: "",
      uiPinInputField: .constant("uiPinInputField"),
      onBiometry: {},
      keyboardHeight: 0)
  }
}
