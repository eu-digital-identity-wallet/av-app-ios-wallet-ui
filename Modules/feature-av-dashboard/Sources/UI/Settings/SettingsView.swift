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
  case changePin
//  case unlockWithBiometrics
//  case language
  case deleteAgeAttestationProof

  var id: String { rawValue }

  var title: String {
    switch self {
    case .changePin: return LocalizableStringKey.changeQuickPinOption.toString
//    case .unlockWithBiometrics: return LocalizableStringKey.settingsUnlockWithBiometrics.toString
//    case .language: return LocalizableStringKey.settingsLanguage.toString
    case .deleteAgeAttestationProof: return LocalizableStringKey.settingsDeleteAllProofsOfAttestation.toString
    }
  }
}

enum SupportMenuItem: String, CaseIterable, Identifiable {
  case termsOfSevice
  case aboutApp

  var id: String { rawValue }

  var title: String {
    switch self {
    case .termsOfSevice: return LocalizableStringKey.settingsTermsOfService.toString
    case .aboutApp: return LocalizableStringKey.settingsAboutThisApp.toString
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
        onSettingItemTap: viewModel.onSettingItemTap(item:),
        onSupportItemTap: viewModel.onSupportItemTap(item:)
      )
    }
    .dialogCompat(
      .custom(""),
      isPresented: $viewModel.isDeletionModalShowing,
      actions: {
        Button(.deleteDocument, role: .destructive) {
          viewModel.onDeleteCredentials()
        }
        Button(.quickPinUpdateCancellationContinue, role: .cancel) {
          viewModel.onShowDeleteModal()
        }
      },
      message: {
        Text(.deleteDocumentConfirmDialog)
      }
    )
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: SettingsState,
  onNavigateBack: @escaping () -> Void,
  onSettingItemTap: @escaping (SettingsMenuItem) -> Void,
  onSupportItemTap: @escaping (SupportMenuItem) -> Void
) -> some View {
  ScrollView {
      VStack(alignment: .leading, spacing: .zero) {
        HStack(alignment: .center, spacing: .zero) {
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
          VStack(alignment: .leading, spacing: .zero) {
            Text(LocalizableStringKey.settings.toString)
              .typography(Theme.shared.font.bodyLarge)
              .foregroundStyle(Theme.shared.color.lightText)
              .padding(.bottom, SPACING_SMALL)

            VStack(alignment: .center, spacing: 25) {
              ForEach(SettingsMenuItem.allCases) { item in
                SettingsItemCellView(title: item.title, onTap: {
                  onSettingItemTap(item)
                })
              }
            }
            .padding()
            .background(Theme.shared.color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
            .padding(.bottom, SPACING_LARGE)

//             Text(LocalizableStringKey.settingsSupport.toString)
//               .typography(Theme.shared.font.bodyLarge)
//               .foregroundStyle(Theme.shared.color.lightText)
//               .padding(.bottom, SPACING_SMALL)
//
//             VStack(alignment: .center, spacing: 20) {
//               ForEach(SupportMenuItem.allCases) { item in
//                   SettingsItemCellView(title: item.title, onTap: {
//                     onSupportItemTap(item)
//                   })
//               }
//             }
//             .padding()
//             .background(Theme.shared.color.white)
//             .cornerRadius(12)
//             .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
//             .padding(.bottom, SPACING_LARGE)
          }
          .padding(.top, SPACING_MEDIUM)
          .padding(.horizontal)

          Spacer()

          HStack {
            Text(LocalizableStringKey.settingsAppVersion.toString)
            .typography(Theme.shared.font.bodyLarge)
            .foregroundStyle(Theme.shared.color.onSurface)

            Text(viewState.appVersion)
            .typography(Theme.shared.font.bodyLarge)
            .foregroundStyle(Theme.shared.color.lightText)

            Spacer()
          }
          .padding(.horizontal)
          .padding(.vertical, SPACING_SMALL)
          .background(Theme.shared.color.surface)
        }
      }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Theme.shared.color.surface)
}

struct SettingsItemCellView: View {

  let title: String
  let onTap: () -> Void

  var body: some View {
    HStack {
      Text(title)
        .typography(Theme.shared.font.headlineSmall)
        .fontWeight(.regular)
      Spacer()
      Theme.shared.image.chevronRight
        .frame(maxWidth: .infinity, alignment: .topTrailing)
        .foregroundColor(Theme.shared.color.onSurface)
      }
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
    onSettingItemTap: {_ in },
    onSupportItemTap: {_ in }
  )
}
