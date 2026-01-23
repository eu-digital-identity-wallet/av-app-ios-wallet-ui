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
import mrz_reader
import logic_core
import logic_resources

/// Utility for extracting MRZ keys from scanned passport data
public struct MRZKeyExtractor {

  /// Extract MRZ key combining document number, date of birth, and expiry date with their check digits
  /// Format: <doc_number><check><dob><check><expiry><check>
  public static func extractMRZKey(from mrzData: MRZData) -> String {
    let rawMRZ = mrzData.rawMRZ
    // Handle different line separators and trim whitespace
    let lines = rawMRZ
      .replacingOccurrences(of: "\r\n", with: "\n")
      .replacingOccurrences(of: "\r", with: "\n")
      .components(separatedBy: "\n")
      .map { $0.trimmingCharacters(in: .whitespaces) }
      .filter { !$0.isEmpty }

    log("MRZ Key Extraction - Type: \(mrzData.mrzType), Lines: \(lines.count)", level: .debug)

    // Try to extract MRZ key from raw MRZ data based on document type
    if let extracted = extractFromRawMRZ(mrzData: mrzData, lines: lines) {
      return extracted
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

  /// Extracts MRZ key from raw MRZ lines based on document type
  /// Returns nil if extraction fails (malformed input), triggering fallback
  private static func extractFromRawMRZ(mrzData: MRZData, lines: [String]) -> String? {
    switch mrzData.mrzType {
    case .td3:
      return extractTD3(lines: lines)
    case .td1:
      return extractTD1(lines: lines)
    case .td2:
      return extractTD2(lines: lines)
    case .unknown:
      return nil
    }
  }

  /// TD3 format (Passports) - 2 lines, 44 chars each
  private static func extractTD3(lines: [String]) -> String? {
    // Line 2 positions:
    // 0-8: Document number (9 chars), 9: check digit
    // 13-18: Date of birth YYMMDD (6 chars), 19: check digit
    // 21-26: Expiry date YYMMDD (6 chars), 27: check digit
    guard lines.count >= 2 else { return nil }
    let line2 = lines[1]
    guard line2.count >= 28 else { return nil }

    let docNumberWithCheck = String(line2.prefix(10))
    let dobStart = line2.index(line2.startIndex, offsetBy: 13)
    let dobEnd = line2.index(line2.startIndex, offsetBy: 20)
    let dobWithCheck = String(line2[dobStart..<dobEnd])
    let expiryStart = line2.index(line2.startIndex, offsetBy: 21)
    let expiryEnd = line2.index(line2.startIndex, offsetBy: 28)
    let expiryWithCheck = String(line2[expiryStart..<expiryEnd])

    return docNumberWithCheck + dobWithCheck + expiryWithCheck
  }

  /// TD1 format (ID Cards) - 3 lines, 30 chars each
  private static func extractTD1(lines: [String]) -> String? {
    // Line 1: 5-13: Document number (9 chars), 14: check digit
    // Line 2: 0-5: DOB (6 chars), 6: check digit, 8-13: Expiry (6 chars), 14: check digit
    guard lines.count >= 2 else { return nil }
    let line1 = lines[0]
    let line2 = lines[1]
    guard line1.count >= 15, line2.count >= 15 else { return nil }

    let docStart = line1.index(line1.startIndex, offsetBy: 5)
    let docEnd = line1.index(line1.startIndex, offsetBy: 15)
    let docNumberWithCheck = String(line1[docStart..<docEnd])
    let dobWithCheck = String(line2.prefix(7))
    let expiryStart = line2.index(line2.startIndex, offsetBy: 8)
    let expiryEnd = line2.index(line2.startIndex, offsetBy: 15)
    let expiryWithCheck = String(line2[expiryStart..<expiryEnd])

    return docNumberWithCheck + dobWithCheck + expiryWithCheck
  }

  /// TD2 format (Official documents) - 2 lines, 36 chars each
  private static func extractTD2(lines: [String]) -> String? {
    // Same structure as TD3 but shorter lines
    // Line 2: 0-8: Document number (9 chars), 9: check digit
    // 13-18: DOB (6 chars), 19: check digit, 21-26: Expiry (6 chars), 27: check digit
    guard lines.count >= 2 else { return nil }
    let line2 = lines[1]
    guard line2.count >= 28 else { return nil }

    let docNumberWithCheck = String(line2.prefix(10))
    let dobStart = line2.index(line2.startIndex, offsetBy: 13)
    let dobEnd = line2.index(line2.startIndex, offsetBy: 20)
    let dobWithCheck = String(line2[dobStart..<dobEnd])
    let expiryStart = line2.index(line2.startIndex, offsetBy: 21)
    let expiryEnd = line2.index(line2.startIndex, offsetBy: 28)
    let expiryWithCheck = String(line2[expiryStart..<expiryEnd])

    return docNumberWithCheck + dobWithCheck + expiryWithCheck
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
