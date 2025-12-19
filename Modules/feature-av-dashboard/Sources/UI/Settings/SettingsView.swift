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

enum SettingsMenuItem: String, CaseIterable, Identifiable {
  case credentials
//  case unlockWithBiometrics
//  case language
  case changePin

  var id: String { rawValue }

  var title: String {
    switch self {
    case .credentials: return LocalizableStringKey.settingsScreenCredentials.toString
    case .changePin: return LocalizableStringKey.settingsScreenSecurity.toString
    }
  }
  var description: String {
    switch self {
    case .credentials: return LocalizableStringKey.settingsScreenDeleteProofs.toString
    case .changePin: return LocalizableStringKey.settingsScreenChangePin.toString
    }
  }
}

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
      toolbarContent: viewModel.toolbarContent()
    ) {
      content(
        viewState: viewModel.viewState,
        onNavigateBack: viewModel.navigateBack,
        onSettingItemTap: viewModel.onSettingItemTap(item:)
      )
    }
    .dialogCompat(
      .custom(LocalizableStringKey.confirmDocRemovalDialogText.toString),
      isPresented: $viewModel.isDeletionModalShowing,
      actions: {
        Button(.confirmDocRemovalDialogDelete, role: .destructive) {
          viewModel.onDeleteCredentials()
        }
        Button(.genericCancel, role: .cancel) {
          viewModel.onShowDeleteModal()
        }
      },
      message: {
        Text(.confirmDocRemovalDialogText)
      }
    )
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: SettingsState,
  onNavigateBack: @escaping () -> Void,
  onSettingItemTap: @escaping (SettingsMenuItem) -> Void
) -> some View {
  ScrollView {
      VStack(alignment: .leading, spacing: .zero) {
        HStack(alignment: .center, spacing: SPACING_EXTRA_SMALL) {
          Theme.shared.image.settingsIcon
          Text(LocalizableStringKey.settings.toString)
            .typography(Theme.shared.font.titleLarge)
            .fontWeight(.medium)
          Spacer()
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
                VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {
                    Text(LocalizableStringKey.settingsScreenAppInfo.toString)
                      .typography(Theme.shared.font.headlineMedium)
                      .fontWeight(.semibold)
                    HStack {
                        Text(LocalizableStringKey.settingsScreenVersion.toString)
                          .typography(Theme.shared.font.bodyLarge)
                        Spacer()
                        Text(viewState.appVersion)
                        .typography(Theme.shared.font.bodyLarge)
                        .foregroundStyle(Theme.shared.color.lightText)
                    }
                }

                VStack(alignment: .leading, spacing: SPACING_LARGE) {
                  ForEach(SettingsMenuItem.allCases) { item in
                      SettingsItemCellView(item: item, onTap: {
                      onSettingItemTap(item)
                    })
                  }
                }
                .padding(.bottom, SPACING_LARGE)
            }
            .padding()

          Spacer()
        }
      }
      .padding(.horizontal, 10)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Theme.shared.color.surface)
}

struct SettingsItemCellView: View {
  let item: SettingsMenuItem
  let onTap: () -> Void

  var body: some View {
      VStack(alignment: .leading) {
          Text(item.title)
            .typography(Theme.shared.font.headlineMedium)
            .fontWeight(.semibold)
          Text(item.description)
              .typography(Theme.shared.font.headlineSmall)
            .fontWeight(.regular)
            .foregroundStyle(item == .credentials ? Theme.shared.color.error : .black)
      }
      .contentShape(Rectangle())
      .onTapGesture {
        onTap()
      }
  }
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
    onSettingItemTap: {_ in }
  )
}
