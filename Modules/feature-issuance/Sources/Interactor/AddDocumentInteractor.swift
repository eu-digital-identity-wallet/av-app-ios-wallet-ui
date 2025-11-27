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
import logic_resources
import feature_common
import logic_core
import OrderedCollections

public protocol AddDocumentInteractor: Sendable {
  func fetchScopedDocuments(with flow: IssuanceFlowUiConfig.Flow) async -> ScopedDocumentsPartialState
  func issueDocument(
    issuerId: String,
    configId: String,
    docTypeIdentifier: DocumentTypeIdentifier
  ) async -> IssueResultPartialState
  func resumeDynamicIssuance() async -> IssueDynamicDocumentPartialState
  func getScopedDocument(configId: String) async throws -> ScopedDocument
  func fetchStoredDocuments(documentIds: [String]) async -> IssueDocumentsPartialState
}

final actor AddDocumentInteractorImpl: AddDocumentInteractor {

  private let walletController: WalletKitController

  init(
    walletController: WalletKitController
  ) {
    self.walletController = walletController
  }

  public func fetchScopedDocuments(with flow: IssuanceFlowUiConfig.Flow) async -> ScopedDocumentsPartialState {
    do {
      let scopedDocuments = try await walletController.getScopedDocuments()

      // Find the document with doctype "eu.europa.ec.av.1" from issuer.dev.ageverification.dev
      // This is the specific credential type needed for age verification QR code scans
      let passportIssuerDoc = scopedDocuments.first {
        $0.issuer == "issuer.dev.ageverification.dev" && $0.docTypeIdentifier == .avAgeOver18
      }

      // Filter out documents from issuer.dev.ageverification.dev since we only want to show the passport entry
      let filteredDocuments = scopedDocuments.filter { $0.issuer != "issuer.dev.ageverification.dev" }

      // Create passport entry that uses issuer.dev.ageverification.dev with doctype "eu.europa.ec.av.1"
      // with a special docTypeIdentifier to trigger the passport enrollment flow
      let passport: ScopedDocument? = passportIssuerDoc.map { doc in
        ScopedDocument(
          name: "Passport or ID Card",
          issuer: doc.issuer,
          configId: doc.configId,
          isPid: false,
          docTypeIdentifier: DocumentTypeIdentifier.other(formatType: "passport"),
          isAgeVerification: false
        )
      }

      var allDocuments = filteredDocuments
      if let passport = passport {
        allDocuments.append(passport)
      }

      let documents: [AddDocumentUIModel] = allDocuments.compactMap { doc in
        if doc.isAgeVerification {
          return .init(listItem: .init(mainContent: MainContent.text(LocalizableStringKey.verificationNationalId),
                                       supportingText: LocalizableStringKey.verificationNationalIdDescription,
                                       leadingIcon: LeadingIcon(image: Theme.shared.image.pidIcon),
                                       trailingContent: nil),
                       isEnabled: true,
                       configId: doc.configId,
                       issuerId: doc.issuer,
                       docTypeIdentifier: doc.docTypeIdentifier)
        } else {
          return .init(
            listItem: .init(
              mainContent: .text(.custom(doc.name)),
              trailingContent: .icon(Theme.shared.image.plus)
            ),
            isEnabled: true,
            configId: doc.configId,
            issuerId: doc.issuer,
            docTypeIdentifier: doc.docTypeIdentifier
          )
        }
      }

      let grouped: [String: [AddDocumentUIModel]] = Dictionary(
        grouping: documents,
        by: { $0.issuerId }
      ).mapValues { section in
        section.sorted(by: compare)
      }

      let ordered = OrderedDictionary<String, [AddDocumentUIModel]>(
        uniqueKeysWithValues: Array(grouped).sorted {
          $0.key.localizedCompare($1.key) == .orderedAscending
        }
      )

      return .success(ordered)
    } catch {
      return .failure(error)
    }

    func compare(_ first: AddDocumentUIModel, _ second: AddDocumentUIModel) -> Bool {
      return first.listItem.mainContent.asString.lowercased() < second.listItem.mainContent.asString.lowercased()
    }
  }

  public func issueDocument(
    issuerId: String,
    configId: String,
    docTypeIdentifier: DocumentTypeIdentifier
  ) async -> IssueResultPartialState {
    do {
      let doc = try await walletController.issueDocument(
        issuerId: issuerId,
        identifier: configId,
        docTypeIdentifier: docTypeIdentifier
      )
      if doc.isDeferred {
        return .deferredSuccess
      } else if let authorizePresentationUrl = doc.authorizePresentationUrl {
        guard
          let presentationUrl = authorizePresentationUrl.toCompatibleUrl(),
          let presentationComponents = URLComponents(url: presentationUrl, resolvingAgainstBaseURL: true) else {
          return .failure(WalletCoreError.unableToIssueAndStore)
        }
        let session = await walletController.startSameDevicePresentation(deepLink: presentationComponents)
        return .dynamicIssuance(session)
      } else {
        return .success(doc.id)
      }
    } catch {
      return .failure(error)
    }
  }

  func resumeDynamicIssuance() async -> IssueDynamicDocumentPartialState {

    guard let pendingData = await walletController.getDynamicIssuancePendingData() else {
      return .noPending
    }

    do {

      let doc = try await walletController.resumePendingIssuance(
        pendingDoc: pendingData.pendingDoc,
        webUrl: pendingData.url
      )

      if doc.status == .deferred {
        return .deferredSuccess
      } else if doc.status == .issued {
        return .success(doc.id)
      } else {
        return .failure(WalletCoreError.unableToIssueAndStore)
      }

    } catch {
      return .failure(error)
    }
  }

  func getScopedDocument(configId: String) async throws -> ScopedDocument {
    try await walletController.getScopedDocuments().first {
      $0.configId == configId
    } ?? ScopedDocument.empty()
  }

  func fetchStoredDocuments(documentIds: [String]) async -> IssueDocumentsPartialState {
    let documents = await walletController.fetchDocuments(with: documentIds)
    let documentsDetails = documents.compactMap {
      $0.transformToDocumentUi(isSensitive: false)
    }

    if documentsDetails.isEmpty {
      return .failure(WalletCoreError.unableFetchDocument)
    }
    return .success(documentsDetails)
  }
}

public enum ScopedDocumentsPartialState: Sendable {
  case success(OrderedDictionary<String, [AddDocumentUIModel]>)
  case failure(Error)
}

public enum IssueResultPartialState: Sendable {
  case success(String)
  case deferredSuccess
  case dynamicIssuance(RemoteSessionCoordinator)
  case failure(Error)
}

public enum IssueDynamicDocumentPartialState: Sendable {
  case success(String)
  case noPending
  case deferredSuccess
  case failure(Error)
}

public enum IssueDocumentsPartialState: Sendable {
  case success([DocumentUIModel])
  case failure(Error)
}
