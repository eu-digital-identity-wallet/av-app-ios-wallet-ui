//
//  AppLandingView.swift
//  feature-av-dashboard
//
//  Created by A200156428 on 30/05/25.
//
import SwiftUI
import feature_common
import logic_resources
import logic_core

struct LandingView<Router: RouterHost>: View {
    @State var viewModel: LandingViewModel<Router>
    @Environment(\.scenePhase) private var scenePhase
    @AccessibilityFocusState private var isTopElementFocused: Bool
    @State private var hasFocusedOnLoad = false

    init(with viewModel: LandingViewModel<Router>) {
      self._viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ContentScreenView(
            padding: .zero,
            canScroll: true,
            errorConfig: viewModel.viewState.error,
            background: Theme.shared.color.surface,
            navigationTitle: nil
        ) {
            content(viewState: viewModel.viewState, onScan: viewModel.onScan, onGetMoreCredentials: viewModel.getMoreCredentials, onSettings: viewModel.onSettings, isTopElementFocused: $isTopElementFocused )
        }
        .task {
            await viewModel.getCredentialDetails()
            await viewModel.onCreate()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task {
                    await viewModel.refreshCredentials()
                }
            }
        }
        .onChange(of: viewModel.viewState.isLoading) { _, isLoading in
            guard !isLoading, !hasFocusedOnLoad, UIAccessibility.isVoiceOverRunning else { return }
            hasFocusedOnLoad = true
            Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(500))
                isTopElementFocused = true
            }
        }
    }
}

@MainActor
@ViewBuilder
private func content(viewState: AppLandingState, onScan: @escaping () -> Void, onGetMoreCredentials: @escaping () -> Void, onSettings: @escaping () -> Void, isTopElementFocused: AccessibilityFocusState<Bool>.Binding) -> some View {
    ZStack(alignment: .bottom) {
        ScrollView {
            VStack(spacing: .zero) {
                HStack(alignment: .center, spacing: .zero) {
                    Spacer()
                        .frame(width: UIScreen.main.bounds.width / 2 - 44)
                    Theme.shared.image.logo
                        .resizable()
                        .frame(width: 57, height: 48)
                        .accessibilityFocused(isTopElementFocused)
                    Spacer()
                    Button(action: {
                        onSettings()
                    }) {
                        Theme.shared.image.settingsIcon
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, SPACING_MEDIUM)
                VStack(alignment: .leading, spacing: .zero) {
                    Text(LocalizableStringKey.landingScreenTitle.toString)
                        .typography(Theme.shared.font.titleLarge)
                        .fontWeight(.medium)
                        .padding(.bottom, SPACING_MEDIUM)
                    Text(LocalizableStringKey.landingScreenSubtitle.toString)
                        .typography(Theme.shared.font.bodyLarge)
                        .foregroundStyle(Theme.shared.color.lightText)
                        .padding(.bottom, SPACING_LARGE)
                        .fixedSize(horizontal: false, vertical: true)
                }

                AgeVerificationCardView(credentialsCount: viewState.credRemainingCount, verifiedAge: viewState.verifiedAge, onTap: onGetMoreCredentials)
                CredentialDetailsView(documentFields: viewState.document.documentFields)
                Spacer()
                    .frame(height: 130)
            }
            .padding()
        }

        // Sticky scan button
        VStack(alignment: .center) {
            Button(action: {
                onScan()

            }) {
                Theme.shared.image.scanButton
                    .frame(height: 76)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
            }
            Text(LocalizableStringKey.landingScreenPrimaryButtonLabelScan.toString)
                .typography(Theme.shared.font.bodyLarge)
                .foregroundStyle(Theme.shared.color.lightText)
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .accessibilityHidden(viewState.isLoading)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.shared.color.surface)
}
