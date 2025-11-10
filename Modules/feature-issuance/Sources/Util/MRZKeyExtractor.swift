import Foundation
import mrz_reader

/// Utility for extracting MRZ keys from scanned passport data
public struct MRZKeyExtractor {

  /// Extract MRZ key combining document number, date of birth, and expiry date with their check digits
  /// Format: <doc_number><check><dob><check><expiry><check>
  public static func extractMRZKey(from mrzData: MRZData) -> String {
    let rawMRZ = mrzData.rawMRZ

    if mrzData.mrzType == .td3 {
      // TD3 format - Line 2 positions:
      // 0-8: Document number (9 chars)
      // 9: Document number check digit
      // 13-19: Date of birth YYMMDD (6 chars)
      // 20: Date of birth check digit
      // 21-27: Expiry date YYMMDD (6 chars)
      // 28: Expiry date check digit

      let lines = rawMRZ.components(separatedBy: "\n")
      if lines.count >= 2 {
        let line2 = lines[1]

        // Extract document number + check digit (positions 0-9)
        let docNumberWithCheck = String(line2.prefix(10))

        // Extract date of birth + check digit (positions 13-19)
        let dobStart = line2.index(line2.startIndex, offsetBy: 13)
        let dobEnd = line2.index(line2.startIndex, offsetBy: 20)
        let dobWithCheck = String(line2[dobStart..<dobEnd])

        // Extract expiry date + check digit (positions 21-27)
        let expiryStart = line2.index(line2.startIndex, offsetBy: 21)
        let expiryEnd = line2.index(line2.startIndex, offsetBy: 28)
        let expiryWithCheck = String(line2[expiryStart..<expiryEnd])

        return docNumberWithCheck + dobWithCheck + expiryWithCheck
      }
    }

    // Fallback: calculate check digits manually if raw MRZ parsing fails
    let docNumber = mrzData.documentNumber.padding(toLength: 9, withPad: "<", startingAt: 0)
    let docCheck = calculateCheckDigit(docNumber)

    let dob = mrzData.dateOfBirth
    let dobCheck = calculateCheckDigit(dob)

    let expiry = mrzData.expirationDate
    let expiryCheck = calculateCheckDigit(expiry)

    return docNumber + String(docCheck) + dob + String(dobCheck) + expiry + String(expiryCheck)
  }

  /// Calculate MRZ check digit using the standard algorithm
  public static func calculateCheckDigit(_ input: String) -> Int {
    let weights = [7, 3, 1]
    var sum = 0

    for (index, char) in input.enumerated() {
      let value: Int
      if char == "<" {
        value = 0
      } else if char.isNumber {
        value = Int(String(char)) ?? 0
      } else {
        // A=10, B=11, ..., Z=35
        value = Int(char.asciiValue ?? 0) - Int(Character("A").asciiValue ?? 0) + 10
      }
      sum += value * weights[index % 3]
    }

    return sum % 10
  }
}
