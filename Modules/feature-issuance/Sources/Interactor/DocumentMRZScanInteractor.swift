import Foundation
import logic_core
import logic_resources
import mrz_reader

public protocol DocumentMRZScanInteractor: Sendable {
  func processMRZData(mrzData: MRZData) async -> MRZProcessingPartialState
}

final class MRZDocumentScanInteractorImpl: DocumentMRZScanInteractor {

  private let walletController: WalletKitController

  init(walletController: WalletKitController) {
    self.walletController = walletController
  }

  func processMRZData(mrzData: MRZData) async -> MRZProcessingPartialState {
    // Validate MRZ data
    guard validateMRZData(mrzData) else {
      return .failure(MRZError.invalidData)
    }

    // Placeholder: Return the document number as identifier
    return .success(mrzData.documentNumber)
  }

  private func validateMRZData(_ mrzData: MRZData) -> Bool {
    // Basic validation checks
    guard !mrzData.documentNumber.isEmpty else { return false }
    guard !mrzData.surname.isEmpty else { return false }
    guard !mrzData.issuingCountry.isEmpty else { return false }

    // Validate expiration date (check if document is not expired)
    if let expirationDate = parseMRZDate(mrzData.expirationDate) {
      guard expirationDate > Date() else { return false }
    }

    return true
  }

  private func parseMRZDate(_ dateString: String) -> Date? {
    // MRZ date format is YYMMDD
    guard dateString.count == 6 else { return nil }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMdd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)

    return formatter.date(from: dateString)
  }
}

public enum MRZProcessingPartialState: Sendable {
  case success(String) // documentId
  case failure(Error)
}

public enum MRZError: Error, LocalizedError, Sendable {
  case invalidData
  case documentExpired
  case processingFailed

  public var errorDescription: String? {
    switch self {
    case .invalidData:
      return LocalizableStringKey.mrzErrorInvalidData.toString
    case .documentExpired:
      return LocalizableStringKey.mrzErrorDocumentExpired.toString
    case .processingFailed:
      return LocalizableStringKey.mrzErrorProcessingFailed.toString
    }
  }
}
