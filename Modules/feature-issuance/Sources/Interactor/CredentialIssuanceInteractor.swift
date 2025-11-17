import logic_resources
import feature_common
import logic_core

public protocol CredentialIssuanceInteractor: Sendable {
  func issueDocument(issuerId: String, configId: String, docTypeIdentifier: DocumentTypeIdentifier) async -> IssueResultPartialState
  func fetchStoredDocuments(documentIds: [String]) async -> IssueDocumentsPartialState
}

final class CredentialIssuanceInteractorImpl: CredentialIssuanceInteractor {

  private let walletController: WalletKitController

  init(
    walletController: WalletKitController
  ) {
    self.walletController = walletController
  }

  public func issueDocument(
    issuerId: String,
    configId: String,
    docTypeIdentifier: DocumentTypeIdentifier
  ) async -> IssueResultPartialState {
    do {
      let doc = try await walletController.issueDocument(issuerId: issuerId, identifier: configId, docTypeIdentifier: docTypeIdentifier)
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
      return .failure(WalletCoreError.unableToIssueAndStore)
    }
  }

  public func fetchStoredDocuments(documentIds: [String]) async -> IssueDocumentsPartialState {
    let documents = walletController.fetchDocuments(with: documentIds)
    let documentsDetails = documents.compactMap {
      $0.transformToDocumentUi(isSensitive: false)
    }

    if documentsDetails.isEmpty {
      return .failure(WalletCoreError.unableFetchDocument)
    }
    return .success(documentsDetails)
  }
}
