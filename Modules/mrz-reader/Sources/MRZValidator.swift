import Foundation

class MRZValidator {

  // Valid MRZ characters (alphanumeric + '<' filler)
  private static let validCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789<")

  // Valid sex indicators
  private static let validSexValues: Set<String> = ["M", "F", "X", "<"]

  private static func log(_ message: String) {
    MRZLogger.log(message)
  }

  // Validate date format (YYMMDD)
  private static func isValidDate(_ dateStr: String) -> Bool {
    guard dateStr.count == 6 else { return false }
    guard let _ = Int(dateStr.prefix(2)),
          let month = Int(dateStr.dropFirst(2).prefix(2)),
          let day = Int(dateStr.suffix(2)) else {
      return false
    }

    // Basic range checks
    guard month >= 1 && month <= 12 else { return false }
    guard day >= 1 && day <= 31 else { return false }

    // Days per month validation (simplified, not accounting for leap years)
    let daysInMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    guard day <= daysInMonth[month - 1] else { return false }

    return true
  }

  // Validate country code
  private static func isValidCountryCode(_ code: String) -> Bool {
    if code.isEmpty { return true }
    return MRZCountryCodes.validCodes.contains(code)
  }

  // Detect MRZ type based on format
  static func detectMRZType(_ mrz: String) -> MRZType {
    let lines = mrz.components(separatedBy: .newlines).filter { !$0.isEmpty }

    switch (lines.count, lines.first?.count ?? 0) {
    case (3, 30): return .td1
    case (2, 36): return .td2
    case (2, 44): return .td3
    default: return .unknown
    }
  }

  // Verify if string is valid MRZ format
  static func isValidMRZ(_ mrz: String) -> Bool {
    let lines = mrz.components(separatedBy: .newlines).filter { !$0.isEmpty }
    let mrzType = detectMRZType(mrz)

    guard mrzType != .unknown else {
      log("❌ Basic validation failed: Unknown MRZ type")
      return false
    }

    // Check each line contains only valid characters
    for (index, line) in lines.enumerated() {
      let lineCharSet = CharacterSet(charactersIn: line)
      if !validCharacters.isSuperset(of: lineCharSet) {
        log("❌ Basic validation failed: Line \(index + 1) contains invalid characters")
        log("   Line: \(line)")
        return false
      }
    }

    // Verify line lengths match expected format
    let isValidLength: Bool
    switch mrzType {
    case .td1:
      isValidLength = lines.count == 3 && lines.allSatisfy { $0.count == 30 }
    case .td2:
      isValidLength = lines.count == 2 && lines.allSatisfy { $0.count == 36 }
    case .td3:
      isValidLength = lines.count == 2 && lines.allSatisfy { $0.count == 44 }
    case .unknown:
      isValidLength = false
    }

    if !isValidLength {
      log("❌ Basic validation failed: Line length mismatch for \(mrzType)")
      for (index, line) in lines.enumerated() {
        log("   Line \(index + 1) length: \(line.count)")
      }
    }

    return isValidLength
  }

  // Calculate check digit (used in MRZ validation)
  static func calculateCheckDigit(_ input: String) -> Int {
    let weights = [7, 3, 1]
    var sum = 0

    for (index, char) in input.enumerated() {
      let value: Int
      if char == "<" {
        value = 0
      } else if char.isNumber {
        value = Int(String(char)) ?? 0
      } else if char.isLetter {
        value = Int(char.asciiValue ?? 0) - 55 // A=10, B=11, etc.
      } else {
        value = 0
      }

      sum += value * weights[index % 3]
    }

    return sum % 10
  }

  // More thorough validation including check digits
  static func isValidMRZWithCheckDigits(_ mrz: String) -> Bool {
    log("======================================")
    log("🔍 Starting MRZ Validation")
    log("======================================")

    guard isValidMRZ(mrz) else {
      log("❌ Failed basic MRZ format validation")
      return false
    }
    log("✅ Basic MRZ format validation passed")

    let mrzType = detectMRZType(mrz)
    log("📄 Detected MRZ Type: \(mrzType)")

    let lines = mrz.components(separatedBy: .newlines).filter { !$0.isEmpty }
    log("📝 Number of lines: \(lines.count)")

    let result: Bool
    switch mrzType {
    case .td3:
      log("🛂 Validating as TD3 (Passport)")
      result = validateTD3CheckDigits(line1: lines[0], line2: lines[1])
    case .td2:
      log("🪪 Validating as TD2 (Official Document)")
      result = validateTD2CheckDigits(line1: lines[0], line2: lines[1])
    case .td1:
      log("🪪 Validating as TD1 (ID Card)")
      result = validateTD1CheckDigits(line1: lines[0], line2: lines[1], line3: lines[2])
    case .unknown:
      log("❌ Unknown MRZ type")
      result = false
    }

    log("======================================")
    log(result ? "✅ Final Result: VALID" : "❌ Final Result: INVALID")
    log("======================================")
    return result
  }

  // TD3 (Passport) Check Digit Validation
  // Line 1: P<ISSUINGCOUNTRY<SURNAME<<GIVENNAMES
  // Line 2: DOCUMENTNUMBER<CHECK<NATIONALITY<DATEOFBIRTH<CHECK<SEX<EXPIRATIONDATE<CHECK<PERSONALNUMBER<<CHECK
  private static func validateTD3CheckDigits(line1: String, line2: String) -> Bool {
    log("=== Starting TD3 (Passport) Validation ===")
    log("Line 1: \(line1)")
    log("Line 2: \(line2)")

    guard line1.count == 44, line2.count == 44 else {
      log("❌ Failed: Line length check (Line1: \(line1.count), Line2: \(line2.count))")
      return false
    }

    // Check document type starts with 'P' for passport
    let docType = String(line1.prefix(2))
    guard line1.hasPrefix("P<") || line1.hasPrefix("P0") else {
      log("❌ Failed: Document type prefix '\(docType)' is not 'P<' or 'P0'")
      return false
    }
    log("✅ Document type: \(docType)")

    // Validate issuing country code (positions 2-4 of line 1)
    let issuingCountry = String(line1.dropFirst(2).prefix(3))
      .replacingOccurrences(of: "<", with: "").trimmingCharacters(in: .whitespaces)
    guard isValidCountryCode(issuingCountry) else {
      log("❌ Failed: Invalid issuing country code '\(issuingCountry)'")
      return false
    }
    log("✅ Issuing country: \(issuingCountry)")

    // Check that line 1 contains the name separator "<<"
    guard line1.contains("<<") else {
      log("❌ Failed: Line 1 does not contain name separator '<<'")
      return false
    }
    log("✅ Name separator found")

    // Validate document number check digit (position 9)
    let docNumber = String(line2.prefix(9))
    let docCheckDigit = Int(String(line2[line2.index(line2.startIndex, offsetBy: 9)])) ?? -1
    let docCalculated = calculateCheckDigit(docNumber)
    guard docCalculated == docCheckDigit else {
      log("❌ Failed: Document number check digit (Expected: \(docCheckDigit), Calculated: \(docCalculated), DocNumber: \(docNumber))")
      return false
    }
    log("✅ Document number check digit valid")

    // Validate nationality (positions 10-12 of line 2)
    let nationality = String(line2.dropFirst(10).prefix(3))
      .replacingOccurrences(of: "<", with: "").trimmingCharacters(in: .whitespaces)
    guard isValidCountryCode(nationality) else {
      log("❌ Failed: Invalid nationality code '\(nationality)'")
      return false
    }
    log("✅ Nationality: \(nationality)")

    // Validate date of birth (positions 13-18 of line 2)
    let dob = String(line2.dropFirst(13).prefix(6))
    guard isValidDate(dob) else {
      log("❌ Failed: Invalid date of birth '\(dob)'")
      return false
    }
    let dobCheckDigit = Int(String(line2[line2.index(line2.startIndex, offsetBy: 19)])) ?? -1
    let dobCalculated = calculateCheckDigit(dob)
    guard dobCalculated == dobCheckDigit else {
      log("❌ Failed: Date of birth check digit (Expected: \(dobCheckDigit), Calculated: \(dobCalculated), DOB: \(dob))")
      return false
    }
    log("✅ Date of birth check digit valid")

    // Validate sex indicator (position 20 of line 2)
    let sex = String(line2.dropFirst(20).prefix(1))
    guard validSexValues.contains(sex) else {
      log("❌ Failed: Invalid sex indicator '\(sex)'")
      return false
    }
    log("✅ Sex indicator: \(sex)")

    // Validate expiration date (positions 21-26 of line 2)
    let expDate = String(line2.dropFirst(21).prefix(6))
    guard isValidDate(expDate) else {
      log("❌ Failed: Invalid expiration date '\(expDate)'")
      return false
    }
    let expCheckDigit = Int(String(line2[line2.index(line2.startIndex, offsetBy: 27)])) ?? -1
    let expCalculated = calculateCheckDigit(expDate)
    guard expCalculated == expCheckDigit else {
      log("❌ Failed: Expiration date check digit (Expected: \(expCheckDigit), Calculated: \(expCalculated), ExpDate: \(expDate))")
      return false
    }
    log("✅ Expiration date check digit valid")

    // Validate personal number check digit (position 42)
    let personalNumber = String(line2.dropFirst(28).prefix(14))
    let personalCheckChar = line2[line2.index(line2.startIndex, offsetBy: 42)]
    // If personal number is not used (all fillers), check digit should also be '<' (value 0)
    let personalCheckDigit = personalCheckChar == "<" ? 0 : (Int(String(personalCheckChar)) ?? -1)
    let personalCalculated = calculateCheckDigit(personalNumber)
    guard personalCalculated == personalCheckDigit else {
      log("❌ Failed: Personal number check digit (Expected: \(personalCheckDigit), Calculated: \(personalCalculated), PersonalNumber: \(personalNumber))")
      return false
    }
    log("✅ Personal number check digit valid")

    // Validate composite check digit (position 44)
    let composite = String(line2.prefix(10)) + String(line2.dropFirst(13).prefix(7)) + String(line2.dropFirst(21).prefix(22))
    let compositeCheckDigit = Int(String(line2[line2.index(line2.startIndex, offsetBy: 43)])) ?? -1
    let compositeCalculated = calculateCheckDigit(composite)
    guard compositeCalculated == compositeCheckDigit else {
      log("❌ Failed: Composite check digit (Expected: \(compositeCheckDigit), Calculated: \(compositeCalculated))")
      log("   Composite string: \(composite)")
      return false
    }
    log("✅ Composite check digit valid")

    log("✅✅✅ TD3 validation passed! ✅✅✅")
    return true
  }

  // TD2 Check Digit Validation
  // Line 1: DOCUMENTTYPE<ISSUINGCOUNTRY<SURNAME<<GIVENNAMES
  // Line 2: DOCUMENTNUMBER<CHECK<NATIONALITY<DATEOFBIRTH<CHECK<SEX<EXPIRATIONDATE<CHECK<<<<<<<CHECK
  private static func validateTD2CheckDigits(line1: String, line2: String) -> Bool {
    guard line1.count == 36, line2.count == 36 else { return false }

    // Validate issuing country code (positions 2-4 of line 1)
    let issuingCountry = String(line1.dropFirst(2).prefix(3))
      .replacingOccurrences(of: "<", with: "").trimmingCharacters(in: .whitespaces)
    guard isValidCountryCode(issuingCountry) else { return false }

    // Check that line 1 contains the name separator "<<"
    guard line1.contains("<<") else { return false }

    // Validate document number check digit (position 9)
    let docNumber = String(line2.prefix(9))
    let docCheckDigit = Int(String(line2[line2.index(line2.startIndex, offsetBy: 9)])) ?? -1
    guard calculateCheckDigit(docNumber) == docCheckDigit else { return false }

    // Validate nationality (positions 10-12 of line 2)
    let nationality = String(line2.dropFirst(10).prefix(3))
    guard isValidCountryCode(nationality) else { return false }

    // Validate date of birth (positions 13-18 of line 2)
    let dob = String(line2.dropFirst(13).prefix(6))
    guard isValidDate(dob) else { return false }
    let dobCheckDigit = Int(String(line2[line2.index(line2.startIndex, offsetBy: 19)])) ?? -1
    guard calculateCheckDigit(dob) == dobCheckDigit else { return false }

    // Validate sex indicator (position 20 of line 2)
    let sex = String(line2.dropFirst(20).prefix(1))
    guard validSexValues.contains(sex) else { return false }

    // Validate expiration date (positions 21-26 of line 2)
    let expDate = String(line2.dropFirst(21).prefix(6))
    guard isValidDate(expDate) else { return false }
    let expCheckDigit = Int(String(line2[line2.index(line2.startIndex, offsetBy: 27)])) ?? -1
    guard calculateCheckDigit(expDate) == expCheckDigit else { return false }

    // Validate composite check digit (position 36)
    let composite = String(line2.prefix(10)) + String(line2.dropFirst(13).prefix(7)) + String(line2.dropFirst(21).prefix(8))
    let compositeCheckDigit = Int(String(line2[line2.index(line2.startIndex, offsetBy: 35)])) ?? -1
    guard calculateCheckDigit(composite) == compositeCheckDigit else { return false }

    return true
  }

  // TD1 (ID Card) Check Digit Validation
  // Line 1: DOCUMENTTYPE<ISSUINGCOUNTRY<DOCUMENTNUMBER<<<<<<<<<CHECK
  // Line 2: DATEOFBIRTH<CHECK<SEX<EXPIRATIONDATE<CHECK<NATIONALITY<<<CHECK
  // Line 3: SURNAME<<GIVENNAMES<<<<<<<<<<<<<
  private static func validateTD1CheckDigits(line1: String, line2: String, line3: String) -> Bool {
    log("=== Starting TD1 (ID Card) Validation ===")
    log("Line 1: \(line1)")
    log("Line 2: \(line2)")
    log("Line 3: \(line3)")

    guard line1.count == 30, line2.count == 30, line3.count == 30 else {
      log("❌ Failed: Line length check (Line1: \(line1.count), Line2: \(line2.count), Line3: \(line3.count))")
      return false
    }

    // Document type
    let docType = String(line1.prefix(2))
    log("📄 Document type: \(docType)")

    // Validate issuing country code (positions 2-4 of line 1)
    let issuingCountry = String(line1.dropFirst(2).prefix(3))
      .replacingOccurrences(of: "<", with: "").trimmingCharacters(in: .whitespaces)
    guard isValidCountryCode(issuingCountry) else {
      log("❌ Failed: Invalid issuing country code '\(issuingCountry)'")
      return false
    }
    log("✅ Issuing country: \(issuingCountry)")

    // Validate document number check digit (position 14 of line 1)
    let docNumber = String(line1.dropFirst(5).prefix(9))
    let docCheckDigit = Int(String(line1[line1.index(line1.startIndex, offsetBy: 14)])) ?? -1
    let docCalculated = calculateCheckDigit(docNumber)
    guard docCalculated == docCheckDigit else {
      log("❌ Failed: Document number check digit (Expected: \(docCheckDigit), Calculated: \(docCalculated), DocNumber: \(docNumber))")
      return false
    }
    log("✅ Document number check digit valid")

    // Validate date of birth (positions 0-5 of line 2)
    let dob = String(line2.prefix(6))
    guard isValidDate(dob) else {
      log("❌ Failed: Invalid date of birth '\(dob)'")
      return false
    }
    let dobCheckDigit = Int(String(line2[line2.index(line2.startIndex, offsetBy: 6)])) ?? -1
    let dobCalculated = calculateCheckDigit(dob)
    guard dobCalculated == dobCheckDigit else {
      log("❌ Failed: Date of birth check digit (Expected: \(dobCheckDigit), Calculated: \(dobCalculated), DOB: \(dob))")
      return false
    }
    log("✅ Date of birth check digit valid")

    // Validate sex indicator (position 7 of line 2)
    let sex = String(line2.dropFirst(7).prefix(1))
    guard validSexValues.contains(sex) else {
      log("❌ Failed: Invalid sex indicator '\(sex)'")
      return false
    }
    log("✅ Sex indicator: \(sex)")

    // Validate expiration date (positions 8-13 of line 2)
    let expDate = String(line2.dropFirst(8).prefix(6))
    guard isValidDate(expDate) else {
      log("❌ Failed: Invalid expiration date '\(expDate)'")
      return false
    }
    let expCheckDigit = Int(String(line2[line2.index(line2.startIndex, offsetBy: 14)])) ?? -1
    let expCalculated = calculateCheckDigit(expDate)
    guard expCalculated == expCheckDigit else {
      log("❌ Failed: Expiration date check digit (Expected: \(expCheckDigit), Calculated: \(expCalculated), ExpDate: \(expDate))")
      return false
    }
    log("✅ Expiration date check digit valid")

    // Validate nationality (positions 15-17 of line 2)
    let nationality = String(line2.dropFirst(15).prefix(3))
      .replacingOccurrences(of: "<", with: "").trimmingCharacters(in: .whitespaces)

    guard isValidCountryCode(nationality) else {
      log("❌ Failed: Invalid nationality code '\(nationality)'")
      return false
    }
    log("✅ Nationality: \(nationality)")

    // Check that line 3 contains the name separator "<<"
    guard line3.contains("<<") else {
      log("❌ Failed: Line 3 does not contain name separator '<<'")
      return false
    }
    log("✅ Name separator found in line 3")

    // Validate composite check digit (position 30 of line 2)
    let composite = String(line1.dropFirst(5).prefix(25)) + String(line2.prefix(7)) + String(line2.dropFirst(8).prefix(7)) + String(line2.dropFirst(18).prefix(11))
    let compositeCheckDigit = Int(String(line2[line2.index(line2.startIndex, offsetBy: 29)])) ?? -1
    let compositeCalculated = calculateCheckDigit(composite)
    guard compositeCalculated == compositeCheckDigit else {
      log("❌ Failed: Composite check digit (Expected: \(compositeCheckDigit), Calculated: \(compositeCalculated))")
      log("   Composite string: \(composite)")
      return false
    }
    log("✅ Composite check digit valid")

    log("✅✅✅ TD1 validation passed! ✅✅✅")
    return true
  }
}
