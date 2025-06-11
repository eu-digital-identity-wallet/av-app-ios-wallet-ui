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

struct AppLandingView<Router: RouterHost>: View {
    @ObservedObject var viewModel: AppLandingViewModel<Router>

    init(with viewModel: AppLandingViewModel<Router>) {
        self.viewModel = viewModel
    }

    var body: some View {
        ContentScreenView(
            padding: .zero,
            canScroll: true,
            errorConfig: viewModel.viewState.error,
            background: Theme.shared.color.surface,
            navigationTitle: .details
        ) {
            content(viewState: viewModel.viewState, onScan: viewModel.onScan)
        }
        .task {
            await viewModel.getCredentialDetails()
        }
    }
}

@MainActor
@ViewBuilder
private func content(viewState: AppLandingState, onScan: @escaping () -> Void) -> some View {
    ScrollView {
        VStack(spacing: .zero) {
            HStack(alignment: .top, spacing: .zero) {
                Spacer()
                    .frame(width: UIScreen.main.bounds.width / 2 - 44)
                Theme.shared.image.logo
                    .resizable()
                    .frame(width: 57,height: 48)
                Spacer()
                Button(action: {
                }) {
                    Theme.shared.image.settingsIcon
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, SPACING_MEDIUM)
            VStack (alignment: .leading, spacing: .zero) {
                Text(LocalizableStringKey.landingScreenTitle.toString)
                    .typography(Theme.shared.font.titleLarge)
                    .fontWeight(.medium)
                    .padding(.bottom, SPACING_MEDIUM)
                Text(LocalizableStringKey.landingScreenbody.toString)
                    .typography(Theme.shared.font.bodyLarge)
                    .foregroundStyle(Theme.shared.color.lightText)
                    .padding(.bottom, SPACING_LARGE)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            AgeVerificationCardView()
            CredentialDetailsView(documentFields: viewState.document.documentFields)
            
            VStack(alignment: .center) {
                Button(action: {
                    onScan()
                }) {
                    Theme.shared.image.scanButton
                        .frame(height: 76)
                        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
                }
                Text(LocalizableStringKey.scanTitle.toString)
                    .typography(Theme.shared.font.bodyLarge)
                    .foregroundStyle(Theme.shared.color.lightText)
            }
            
            Spacer()
        }
        .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.shared.color.surface)
}
