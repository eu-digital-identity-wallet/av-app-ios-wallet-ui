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
import feature_common
import logic_resources
import logic_core

struct AddDocumentView<Router: RouterHost>: View {

  @State private var viewModel: AddDocumentViewModel<Router>

  private var contentSize: CGFloat = 0.0

  init(with viewModel: AddDocumentViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
    self.contentSize = getScreenRect().width / 2.0
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error,
      navigationTitle: .custom(""),
      isLoading: viewModel.viewState.isLoading,
      toolbarContent: viewModel.toolbarContent()
    ) {
      if viewModel.viewState.addDocumentCellModels.isEmpty {
        noDocumentsFound()
      } else {
        content(
          viewState: viewModel.viewState
        ) { issuerId, configId, identifier in
          viewModel.onClick(
            issuerId: issuerId,
            configId: configId,
            docTypeIdentifier: identifier
          )
        }
      }

      if viewModel.viewState.showFooterScanner {
        VSpacer.extraSmall()
      }
    }
    .task {
      await self.viewModel.initialize()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: AddDocumentViewState,
  action: @escaping (String, String, DocumentTypeIdentifier) -> Void
) -> some View {

  VStack(spacing: SPACING_MEDIUM_LARGE) {
    OnboardingTabsView(steps: Onboardingsteps.allCases,
                       selectedIndex: 3)
    ScrollView {
        LazyVStack(alignment: .leading, spacing: SPACING_MEDIUM_SMALL) {

        Text(.onboardingVerificationTitle)
          .typography(Theme.shared.font.titleMedium)
          .fontWeight(.medium)
          .frame(maxWidth: .infinity, alignment: .leading)
          .foregroundStyle(Theme.shared.color.onSurface)
          .accessibilityAddTraits(.isHeader)

        Text(.onboardingVerificationDescription)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundStyle(Theme.shared.color.onSurface)
          .accessibilityLocator(AddDocumentLocators.subtitle)
          .padding(.bottom, SPACING_MEDIUM_SMALL)

        ForEach(viewState.addDocumentCellModels.elements, id: \.key) { pair in

          let models = pair.value
          let trailingRemovedModels = models.map { model in
            var copy = model
            copy.listItem.trailingContent = nil
            return copy
          }

          ForEach(trailingRemovedModels, id: \.id) { cell in
            WrapCardView {
              WrapListItemView(
                listItem: cell.listItem,
                locator: AddDocumentLocators.attestation(
                  "\(cell.issuerId)_\(cell.docTypeIdentifier)"
                ),
                isLoading: cell.isLoading,
                accessibilityHint: cell.opensExternalContext
                  ? .onboardingVerificationNationalIdHint
                  : nil,
                action: { action(cell.issuerId, cell.configId, cell.docTypeIdentifier) }
              )
            }
          }
        }
      }
      .padding(.horizontal, Theme.shared.dimension.padding)
      .padding(.bottom)
    }
  }
  .disabled(viewState.addDocumentCellModels.allSatisfy { $0.value.isEmpty })
}

@MainActor
@ViewBuilder
private func noDocumentsFound() -> some View {
  VStack(spacing: .zero) {
    Text(.issuanceAddDocumentSubtitle)
      .typography(Theme.shared.font.bodyLarge)
      .foregroundStyle(Theme.shared.color.onSurface)

    Spacer()
    ContentEmptyView(
      title: .issuanceAddDocumentNoOptions
    )
    Spacer()
  }
  .padding(.horizontal, Theme.shared.dimension.padding)
}

#Preview {
  let viewState = AddDocumentViewState(
    addDocumentCellModels: AddDocumentUIModel.mocks,
    error: nil,
    config: IssuanceFlowUiConfig(flow: .noDocument),
    showFooterScanner: true
  )

  content(
    viewState: viewState
  ) { _, _, _ in }
}

#Preview {
  let viewState = AddDocumentViewState(
    addDocumentCellModels: AddDocumentUIModel.mocks,
    error: nil,
    config: IssuanceFlowUiConfig(flow: .noDocument),
    showFooterScanner: true
  )
}
