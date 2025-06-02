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
            content(state: viewModel.viewState, onScan: viewModel.onScan)
        }
    }
}

@MainActor
@ViewBuilder
private func content(state: AppLandingState, onScan: @escaping () -> Void) -> some View {
    ScrollView {
        GeometryReader { geometry in
            VStack(spacing: .zero) {
                HStack(alignment: .top, spacing: .zero) {
                    Spacer()
                        .frame(width: geometry.size.width / 2 - 44)
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
                    Text(LocalizableStringKey.splashTitle.toString)
                        .font(Theme.shared.font.titleLarge.font)
                        .fontWeight(.medium)
                        .padding(.bottom, SPACING_MEDIUM)
                    Text(LocalizableStringKey.landingScreenbody.toString)
                        .foregroundStyle(Theme.shared.color.lightText)
                        .font(Theme.shared.font.bodyLarge.font)
                        .padding(.bottom, SPACING_LARGE)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                AgeVerificationCardView()
                
                CredentialDetailsView()
                
                VStack(alignment: .center) {
                    Button(action: {
                        onScan()
                    }) {
                        Theme.shared.image.scanButton
                            .frame(height: 76)
                            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
                    }
                    Text(LocalizableStringKey.scanTitle.toString)
                        .foregroundStyle(Theme.shared.color.lightText)
                        .font(Theme.shared.font.bodyLarge.font)
                }
                
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.shared.color.surface)
    }
    
}
