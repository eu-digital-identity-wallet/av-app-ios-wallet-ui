import Foundation
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

/// Utility for parsing and formatting MRZ (Machine Readable Zone) dates.
/// Handles both 2-digit year formats (YYMMDD and DD/MM/YY) with configurable thresholds
public struct MRZDateUtils {

  /// Date threshold for birth dates (99 years ago from present)
  /// Example: If current year is 2025, birth dates range from 1926-2025
  public static let birthDateThreshold = 99

  /// Date threshold for expiry dates (49 years in future from present)
  /// Example: If current year is 2025, expiry dates range from 1976-2075
  public static let expiryDateThreshold = 49

  /// Parse an MRZ date string with a specified threshold
  ///
  /// - Parameters:
  ///   - dateString: The date string to parse (YYMMDD or DD/MM/YY format)
  ///   - threshold: The threshold in years to determine the date range
  /// - Returns: A Date object if parsing succeeds, nil otherwise
  public static func parseMRZDate(_ dateString: String, threshold: Int) -> Date? {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: 0)

    let calendar = Calendar.current
    let currentYear = calendar.component(.year, from: Date())

    // Set pivot year: currentYear - threshold
    // This creates a window of [pivotYear, pivotYear + 100]
    let pivotYear = currentYear - threshold

    // Create the pivot date for 2-digit year parsing
    var dateComponents = DateComponents()
    dateComponents.year = pivotYear
    dateComponents.month = 1
    dateComponents.day = 1
    dateComponents.timeZone = TimeZone(secondsFromGMT: 0)

    if let pivotDate = calendar.date(from: dateComponents) {
      // Set the start date for 2-digit year interpretation
      // Years >= pivotYear will be in 1900s, years < pivotYear will be in 2000s
      formatter.twoDigitStartDate = pivotDate
    }

    // Try parsing as YYMMDD format (from NFC passport data)
    if dateString.count == 6 {
      formatter.dateFormat = "yyMMdd"
      return formatter.date(from: dateString)
    }

    // Try parsing as DD/MM/YY format (from MRZ ID card data)
    if dateString.count == 8 && dateString.contains("/") {
      formatter.dateFormat = "dd/MM/yy"
      return formatter.date(from: dateString)
    }

    return nil
  }

  /// Parse a birth date string using the birth date threshold
  ///
  /// - Parameter dateString: The birth date string to parse
  /// - Returns: A Date object if parsing succeeds, nil otherwise
  public static func parseBirthDate(_ dateString: String) -> Date? {
    return parseMRZDate(dateString, threshold: birthDateThreshold)
  }

  /// Parse an expiry date string using the expiry date threshold
  ///
  /// - Parameter dateString: The expiry date string to parse
  /// - Returns: A Date object if parsing succeeds, nil otherwise
  public static func parseExpiryDate(_ dateString: String) -> Date? {
    return parseMRZDate(dateString, threshold: expiryDateThreshold)
  }

  /// Format an MRZ date string to a readable format using locale-aware formatting
  ///
  /// - Parameters:
  ///   - dateString: The date string to format
  ///   - threshold: The threshold to use for parsing
  ///   - locale: The locale to use for formatting (default: current locale)
  /// - Returns: A formatted date string, or the original string if parsing fails
  ///
  /// Examples:
  /// - US locale: "January 1, 2000"
  /// - UK/European locale: "1 January 2000"
  public static func formatMRZDate(
    _ dateString: String,
    threshold: Int,
    locale: Locale = .current
  ) -> String {
    guard let date = parseMRZDate(dateString, threshold: threshold) else {
      return dateString
    }

    let displayFormatter = DateFormatter()
    displayFormatter.locale = locale
    displayFormatter.timeZone = TimeZone(secondsFromGMT: 0)

    // Use medium date style which shows month as text and respects locale ordering
    // US: "Jan 1, 2000" or "January 1, 2000"
    // UK/Europe: "1 Jan 2000" or "1 January 2000"
    displayFormatter.dateStyle = .long
    displayFormatter.timeStyle = .none

    return displayFormatter.string(from: date)
  }

  /// Format a birth date string to a readable format using locale-aware formatting
  ///
  /// - Parameters:
  ///   - dateString: The birth date string to format
  ///   - locale: The locale to use for formatting (default: current locale)
  /// - Returns: A formatted date string
  public static func formatBirthDate(
    _ dateString: String,
    locale: Locale = .current
  ) -> String {
    return formatMRZDate(dateString, threshold: birthDateThreshold, locale: locale)
  }

  /// Format an expiry date string to a readable format using locale-aware formatting
  ///
  /// - Parameters:
  ///   - dateString: The expiry date string to format
  ///   - locale: The locale to use for formatting (default: current locale)
  /// - Returns: A formatted date string
  public static func formatExpiryDate(
    _ dateString: String,
    locale: Locale = .current
  ) -> String {
    return formatMRZDate(dateString, threshold: expiryDateThreshold, locale: locale)
  }

  /// Check if a person is under a specified age based on their birth date
  ///
  /// - Parameters:
  ///   - birthDateString: The birth date string
  ///   - ageThreshold: The age threshold to check against (default: 18)
  /// - Returns: true if the person is under the specified age, false otherwise
  public static func isUnderAge(_ birthDateString: String, ageThreshold: Int = 18) -> Bool {
    guard let birthDate = parseBirthDate(birthDateString) else {
      return false
    }

    let calendar = Calendar.current
    let now = Date()
    let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)

    guard let age = ageComponents.year else { return false }
    return age < ageThreshold
  }

  /// Check if a document has expired based on its expiry date
  ///
  /// - Parameter expiryDateString: The expiry date string
  /// - Returns: true if the document has expired, false otherwise
  public static func isExpired(_ expiryDateString: String) -> Bool {
    guard let expiryDate = parseExpiryDate(expiryDateString) else {
      return false
    }

    return expiryDate < Date()
  }
}
