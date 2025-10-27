import Foundation
import CoreGraphics

// MARK: - MRZ Type
public enum MRZType: Sendable {
  case td1  // 3 lines, 30 characters each (ID cards)
  case td2  // 2 lines, 36 characters each (official documents)
  case td3  // 2 lines, 44 characters each (passports)
  case unknown
}

// MARK: - MRZ Data Model
public struct MRZData: Sendable {
  public let documentType: String
  public let documentNumber: String
  public let issuingCountry: String
  public let surname: String
  public let givenNames: String
  public let nationality: String
  public let dateOfBirth: String
  public let sex: String
  public let expirationDate: String
  public let personalNumber: String
  public let rawMRZ: String
  public let mrzType: MRZType

  public init(
    documentType: String,
    documentNumber: String,
    issuingCountry: String,
    surname: String,
    givenNames: String,
    nationality: String,
    dateOfBirth: String,
    sex: String,
    expirationDate: String,
    personalNumber: String,
    rawMRZ: String,
    mrzType: MRZType
  ) {
    self.documentType = documentType
    self.documentNumber = documentNumber
    self.issuingCountry = issuingCountry
    self.surname = surname
    self.givenNames = givenNames
    self.nationality = nationality
    self.dateOfBirth = dateOfBirth
    self.sex = sex
    self.expirationDate = expirationDate
    self.personalNumber = personalNumber
    self.rawMRZ = rawMRZ
    self.mrzType = mrzType
  }
}

// MARK: - Detection Result
public struct DetectionResult: Sendable {
  public let documentRect: CGRect?
  public let mrzRect: CGRect?
  public let mrzData: MRZData?

  public init(documentRect: CGRect?, mrzRect: CGRect?, mrzData: MRZData?) {
    self.documentRect = documentRect
    self.mrzRect = mrzRect
    self.mrzData = mrzData
  }
}

// MARK: - Sendable Wrapper for non-Sendable types
struct UncheckedSendableWrapper<T>: @unchecked Sendable {
  let value: T

  init(_ value: T) {
    self.value = value
  }
}
