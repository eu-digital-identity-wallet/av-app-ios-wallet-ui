import Foundation
import IdentityDocumentServices

@available(iOS 26.0, *)
actor DocumentRegistrationManager {

  @MainActor static let shared = DocumentRegistrationManager()

  private init() {}

  // MARK: - Private Helper

  /// Creates a registration store only if the API is available (iOS 26+)
  @available(iOS 26, *)
  private func makeStore() -> IdentityDocumentProviderRegistrationStore {
    IdentityDocumentProviderRegistrationStore()
  }

  // MARK: - Public API

  /// Adds a registration for a stored document
  func addRegistration(
    mobileDocumentType: String,
    supportedAuthorityKeyIdentifiers: [Data],
    documentIdentifier: String,
    invalidationDate: Date?
  ) async throws {

    let store = makeStore()

    let registration = MobileDocumentRegistration(
      mobileDocumentType: mobileDocumentType,
      supportedAuthorityKeyIdentifiers: supportedAuthorityKeyIdentifiers,
      documentIdentifier: documentIdentifier,
      invalidationDate: invalidationDate
    )

    try await store.addRegistration(registration)
  }

  /// Removes a registration based on the document identifier
  func removeRegistration(documentIdentifier: String) async throws {

    let store = makeStore()

    try await store.removeRegistration(forDocumentIdentifier: documentIdentifier)
  }
}

// MARK: - Errors

enum RegistrationError: Error {
  case apiNotAvailable
  case registrationNotFound
}
