import Foundation
import logic_core
import logic_resources
import NFCPassportReader

public protocol NFCDocumentReaderInteractor: Sendable {
  func readPassport(mrzKey: String) async -> NFCDocumentReadingPartialState
}

final class NFCPassportReaderInteractorImpl: NFCDocumentReaderInteractor {

  private let walletController: WalletKitController

  init(walletController: WalletKitController) {
    self.walletController = walletController
  }

  func readPassport(mrzKey: String) async -> NFCDocumentReadingPartialState {
    let startTime = Date()

    do {
      log("Starting passport read with MRZ key length: \(mrzKey.count)", level: .info)

      let passportReader = PassportReader()

      let nfcModel = try await passportReader.readPassport(
        mrzKey: mrzKey,
        tags: [.COM, .DG1, .DG2, .SOD],
        skipSecureElements: true,
        skipPACE: false
      )

      let duration = Date().timeIntervalSince(startTime)
      log("Successfully read passport in \(String(format: "%.2f", duration))s", level: .info)

      // Log success metrics
      logNFCResult(success: true, duration: duration, error: nil)

      // Extract the required data
      let documentData = extractPassportData(from: nfcModel)
      return .success(documentData)

    } catch let error as NFCPassportReaderError {
      let duration = Date().timeIntervalSince(startTime)
      let mappedError = mapError(error)
      log("NFC Error: \(error) after \(String(format: "%.2f", duration))s", level: .error)

      // Log failure metrics
      logNFCResult(success: false, duration: duration, error: mappedError)

      return .failure(mappedError)
    } catch {
      let duration = Date().timeIntervalSince(startTime)
      log("NFC Unexpected Error: \(error) after \(String(format: "%.2f", duration))s", level: .error)

      // Log failure metrics
      logNFCResult(success: false, duration: duration, error: .unexpectedError)

      return .failure(.unexpectedError)
    }
  }

  private func logNFCResult(success: Bool, duration: TimeInterval, error: NFCError?) {
    let status = success ? "SUCCESS" : "FAILURE"
    let errorType = error?.localizedDescription ?? "N/A"

    let message = """
      NFC Analytics:
      - Status: \(status)
      - Duration: \(String(format: "%.2f", duration))s
      - Error: \(errorType)
      - Timestamp: \(Date())
      """

    log(message, level: success ? .info : .warning)
  }

  private func extractPassportData(from nfcModel: NFCPassportModel) -> DocumentData {
    // Extract data from the passport model
    let birthDate = nfcModel.dateOfBirth
    let expiryDate = nfcModel.documentExpiryDate
    let documentNumber = nfcModel.documentNumber

    // Extract photo from DG2
    var photoData: Data?
    if let dg2 = nfcModel.dataGroupsRead[.DG2] as? DataGroup2 {
      photoData = Data(dg2.imageData)
    }

    return DocumentData(
      birthDate: birthDate,
      expiryDate: expiryDate,
      documentNumber: documentNumber,
      photo: photoData
    )
  }

  private func mapError(_ error: NFCPassportReaderError) -> NFCError {
    switch error {
    case .TagNotValid:
      return .tagNotValid
    case .MoreThanOneTagFound:
      return .moreThanOneTag
    case .ConnectionError:
      return .connectionError
    case .UserCanceled:
      return .userCanceled
    case .InvalidMRZKey:
      return .invalidMRZKey
    case .UnexpectedError:
      return .unexpectedError
    case .NFCNotSupported:
      return .nfcNotSupported
    default:
      return .readingFailed
    }
  }
}

public struct DocumentData: Sendable {
  public let birthDate: String?
  public let expiryDate: String?
  public let documentNumber: String
  public let photo: Data?
}

public enum NFCDocumentReadingPartialState: Sendable {
  case success(DocumentData)
  case failure(NFCError)
}

public enum NFCError: Error, LocalizedError, Sendable {
  case tagNotValid
  case moreThanOneTag
  case connectionError
  case userCanceled
  case invalidMRZKey
  case unexpectedError
  case readingFailed
  case missingData
  case nfcNotSupported

  public var errorDescription: String? {
    switch self {
    case .tagNotValid:
      return LocalizableStringKey.nfcErrorTagNotValid.toString
    case .moreThanOneTag:
      return LocalizableStringKey.nfcErrorMoreThanOneTag.toString
    case .connectionError:
      return LocalizableStringKey.nfcErrorConnection.toString
    case .userCanceled:
      return LocalizableStringKey.nfcErrorUserCanceled.toString
    case .invalidMRZKey:
      return LocalizableStringKey.nfcErrorInvalidMrzKey.toString
    case .unexpectedError:
      return LocalizableStringKey.nfcErrorUnexpected.toString
    case .readingFailed:
      return LocalizableStringKey.nfcErrorReadingFailed.toString
    case .missingData:
      return LocalizableStringKey.nfcErrorMissingData.toString
    case .nfcNotSupported:
      return "NFC is not supported on this device. Please use a physical iPhone 7 or later to scan passports."
    }
  }
}
