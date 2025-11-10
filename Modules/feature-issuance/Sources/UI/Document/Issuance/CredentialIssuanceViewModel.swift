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

import Foundation
import logic_ui
import logic_core
import feature_common

@Copyable
struct CredentialIssuanceViewState: ViewState {
  let isLoading: Bool
  let error: ContentErrorView.Config?
}

final class CredentialIssuanceViewModel<Router: RouterHost>: ViewModel<Router, CredentialIssuanceViewState> {

  private let interactor: CredentialIssuanceInteractor
  private let config: DocumentEnrollmentUiConfig

  init(
    router: Router,
    config: DocumentEnrollmentUiConfig,
    interactor: CredentialIssuanceInteractor
  ) {
    self.interactor = interactor
    self.config = config
    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        error: nil
      )
    )
  }

  func issueCredential() async {
    guard let configId = config.configId,
          let docTypeIdentifier = config.docTypeIdentifier else {
      await MainActor.run {
        setState {
          $0.copy(
            isLoading: false,
            error: .init(
              description: .custom("Missing configuration for credential issuance"),
              cancelAction: self.router.pop()
            )
          )
        }
      }
      return
    }

    let result = await interactor.issueDocument(
      configId: configId,
      docTypeIdentifier: docTypeIdentifier
    )

    await MainActor.run {
      switch result {
      case .success(let documentId):
        // Fetch the issued document details
        Task {
          let documentsState = await interactor.fetchStoredDocuments(documentIds: [documentId])
          await MainActor.run {
            switch documentsState {
            case .success(let documents):
              // Navigate to success screen
              router.push(
                with: .featureIssuanceModule(
                  .issuanceSuccess(
                    config: DocumentSuccessUIConfig(
                      successNavigation: .push(screen: .featureAVDashboardModule(.appLanding)),
                      relyingParty: documents.first?.issuer?.name,
                      issuerLogoUrl: documents.first?.issuer?.logoUrl,
                      relyingPartyIsTrusted: false
                    ),
                    requestItems: documents.map { item in
                      ListItemSection(
                        id: item.id,
                        title: item.documentName,
                        listItems: item.documentFields
                      )
                    }
                  )
                )
              )
            case .failure:
              setState {
                $0.copy(
                  isLoading: false,
                  error: .init(
                    description: .custom("Failed to fetch issued document"),
                    cancelAction: self.router.push(with: .featureAVDashboardModule(.appLanding))
                  )
                )
              }
            }
          }
        }

      case .deferredSuccess:
        // Navigate to deferred success screen
        router.push(
          with: .featureCommonModule(
            .genericSuccess(
              config: UIConfig.Success(
                title: .init(
                  value: .inProgress,
                  color: Theme.shared.color.pending
                ),
                subtitle: .issuanceSuccessDeferredCaption([config.configId ?? "credential"]),
                buttons: [
                  .init(
                    title: .okButton,
                    style: .primary,
                    navigationType: .push(screen: .featureAVDashboardModule(.appLanding))
                  )
                ],
                visualKind: .customIcon(
                  Theme.shared.image.documentSuccessPending,
                  .clear
                )
              )
            )
          )
        )

      case .dynamicIssuance:
        // Handle dynamic issuance if needed
        setState {
          $0.copy(
            isLoading: false,
            error: .init(
              description: .custom("Dynamic issuance not yet supported"),
              cancelAction: self.router.push(with: .featureAVDashboardModule(.appLanding))
            )
          )
        }

      case .failure(let error):
        setState {
          $0.copy(
            isLoading: false,
            error: .init(
              description: .custom("Failed to issue credential: \(error.localizedDescription)"),
              cancelAction: self.router.push(with: .featureAVDashboardModule(.appLanding))
            )
          )
        }
      }
    }
  }
}
