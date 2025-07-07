//
//  SettingsView.swift
//  feature-av-dashboard
//
//  Created by A200301424 on 07/07/25.
//

import SwiftUI
import feature_common
import logic_resources
import logic_core

struct SettingsView<Router: RouterHost>: View {
  @ObservedObject var viewModel: SettingsViewModel<Router>
  
  init(with viewModel: SettingsViewModel<Router>) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error,
      background: Theme.shared.color.surface,
    ) {
      content(
        viewState: viewModel.viewState,
        onNavigateBack: viewModel.navigateBack,
        onShowDeleteModal: viewModel.onShowDeleteModal
      )
    }
    .confirmationDialog(
      title: .custom(""),
      message: .deleteDocumentConfirmDialog,
      destructiveText: .deleteDocument,
      baseText: .cancelButton,
      isPresented: $viewModel.isDeletionModalShowing,
      destructiveAction: {
        viewModel.onDeleteCredentials()
      },
      baseAction: viewModel.onShowDeleteModal()
    )
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: SettingsState,
  onNavigateBack: @escaping () -> Void,
  onShowDeleteModal: @escaping () -> Void
) -> some View {
  VStack(alignment: .leading, spacing: .zero) {
    HStack(alignment: .center, spacing: .zero) {
      Button(action: {
        onNavigateBack()
      }) {
        Theme.shared.image.arrowLeft
          .frame(width: 24, height: 24)
      }
      .buttonStyle(.plain)
      
      Spacer()
      
      Text(LocalizableStringKey.settings.toString)
        .typography(Theme.shared.font.titleLarge)
        .fontWeight(.medium)
      
      Spacer()
      
      // Invisible button to balance the layout
      Button(action: {}) {
        Color.clear
          .frame(width: 24, height: 24)
      }
      .disabled(true)
    }
    .padding()
    
    if viewState.isLoading {
      Spacer()
      HStack {
        Spacer()
        ProgressView()
        Spacer()
      }
      Spacer()
    } else {
      // Settings content
      VStack(alignment: .leading, spacing: SPACING_LARGE) {
        
        // App Version Section
        VStack(alignment: .leading, spacing: SPACING_SMALL) {
          Text("App Information")
            .typography(Theme.shared.font.headlineSmall)
            .fontWeight(.medium)
            .padding(.horizontal)
          
          HStack {
            Text("Version")
              .typography(Theme.shared.font.bodyLarge)
              .foregroundStyle(Theme.shared.color.onSurface)
            
            Spacer()
            
            Text(viewState.appVersion)
              .typography(Theme.shared.font.bodyLarge)
              .foregroundStyle(Theme.shared.color.lightText)
          }
          .padding(.horizontal)
          .padding(.vertical, SPACING_SMALL)
          .background(Theme.shared.color.surface)
        }
        
        // Credentials Section
        VStack(alignment: .leading, spacing: SPACING_SMALL) {
          Text("Credentials")
            .typography(Theme.shared.font.headlineSmall)
            .fontWeight(.medium)
            .padding(.horizontal)
          
          Button(action: {
            onShowDeleteModal()
          }) {
            HStack {
              Text("Delete Age Verification Credentials")
                .typography(Theme.shared.font.bodyLarge)
                .foregroundStyle(Theme.shared.color.error)
              
              Spacer()
              
              if viewState.isDeletingCredentials {
                ProgressView()
                  .scaleEffect(0.8)
              }
            }
            .padding(.horizontal)
            .padding(.vertical, SPACING_MEDIUM)
            .background(Theme.shared.color.surface)
          }
          .disabled(viewState.isDeletingCredentials)
          .buttonStyle(.plain)
        }
        
        Spacer()
      }
      .padding(.top, SPACING_MEDIUM)
    }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Theme.shared.color.surface)
}

#Preview {
  content(
    viewState: SettingsState(
      isLoading: false,
      error: nil,
      appVersion: "1.0.0",
      isDeletingCredentials: false
    ),
    onNavigateBack: {},
    onShowDeleteModal: {}
  )
}
