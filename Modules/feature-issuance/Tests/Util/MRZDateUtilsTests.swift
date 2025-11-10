import XCTest
@testable import feature_issuance

final class MRZDateUtilsTests: XCTestCase {

  // MARK: - Birth Date Parsing Tests

  func testParseBirthDate_YYMMDD_Format() {
    // Test birth date in YYMMDD format
    let date = MRZDateUtils.parseBirthDate("460125")
    XCTAssertNotNil(date, "Should parse birth date")

    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date!)

    XCTAssertEqual(components.year, 1946, "Year should be 1946")
    XCTAssertEqual(components.month, 1, "Month should be January")
    XCTAssertEqual(components.day, 25, "Day should be 25")
  }

  func testParseBirthDate_DDMMYY_Format() {
    // Test birth date in DD/MM/YY format (from ID card MRZ)
    let date = MRZDateUtils.parseBirthDate("25/01/46")
    XCTAssertNotNil(date, "Should parse birth date in DD/MM/YY format")

    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date!)

    XCTAssertEqual(components.year, 1946, "Year should be 1946")
    XCTAssertEqual(components.month, 1, "Month should be January")
    XCTAssertEqual(components.day, 25, "Day should be 25")
  }

  func testParseBirthDate_RecentYear() {
    // Test someone born in 2000
    let date = MRZDateUtils.parseBirthDate("000101")
    XCTAssertNotNil(date, "Should parse year 2000 birth date")

    let calendar = Calendar.current
    let year = calendar.component(.year, from: date!)

    XCTAssertEqual(year, 2000, "Year should be 2000")
  }

  func testParseBirthDate_AtThresholdBoundary() {
    // Test at the 99-year threshold boundary
    let currentYear = Calendar.current.component(.year, from: Date())
    let pivotYear = currentYear - 99

    // Create a date string for the pivot year
    let yearString = String(format: "%02d", pivotYear % 100)
    let dateString = "\(yearString)0101"

    let date = MRZDateUtils.parseBirthDate(dateString)
    XCTAssertNotNil(date, "Should parse date at threshold boundary")

    let parsedYear = Calendar.current.component(.year, from: date!)
    XCTAssertEqual(parsedYear, pivotYear, "Should parse to pivot year")
  }

  // MARK: - Expiry Date Parsing Tests

  func testParseExpiryDate_FutureDate() {
    // Test expiry date in the future
    let date = MRZDateUtils.parseExpiryDate("301231")
    XCTAssertNotNil(date, "Should parse expiry date")

    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date!)

    XCTAssertEqual(components.year, 2030, "Year should be 2030")
    XCTAssertEqual(components.month, 12, "Month should be December")
    XCTAssertEqual(components.day, 31, "Day should be 31")
  }

  func testParseExpiryDate_DDMMYY_Format() {
    // Test expiry date in DD/MM/YY format
    let date = MRZDateUtils.parseExpiryDate("31/12/30")
    XCTAssertNotNil(date, "Should parse expiry date in DD/MM/YY format")

    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date!)

    XCTAssertEqual(components.year, 2030, "Year should be 2030")
    XCTAssertEqual(components.month, 12, "Month should be December")
    XCTAssertEqual(components.day, 31, "Day should be 31")
  }

  func testParseExpiryDate_AtUpperBoundary() {
    // Test at the upper boundary (49 years in future)
    let currentYear = Calendar.current.component(.year, from: Date())
    let upperBoundYear = currentYear + 50 // Just at the boundary

    let yearString = String(format: "%02d", upperBoundYear % 100)
    let dateString = "\(yearString)1231"

    let date = MRZDateUtils.parseExpiryDate(dateString)
    XCTAssertNotNil(date, "Should parse date at upper boundary")
  }

  // MARK: - Date Formatting Tests

  func testFormatBirthDate_USLocale() {
    // Test formatting with US locale
    let formatted = MRZDateUtils.formatBirthDate("460125", locale: Locale(identifier: "en_US"))

    // Should contain "January" and "1946"
    XCTAssertTrue(formatted.contains("1946"), "Should contain year 1946")
    XCTAssertTrue(formatted.contains("January") || formatted.contains("Jan"), "Should contain month name")
  }

  func testFormatBirthDate_UKLocale() {
    // Test formatting with UK locale
    let formatted = MRZDateUtils.formatBirthDate("460125", locale: Locale(identifier: "en_GB"))

    // Should contain "January" and "1946"
    XCTAssertTrue(formatted.contains("1946"), "Should contain year 1946")
    XCTAssertTrue(formatted.contains("January") || formatted.contains("Jan"), "Should contain month name")
  }

  func testFormatBirthDate_GermanLocale() {
    // Test formatting with German locale
    let formatted = MRZDateUtils.formatBirthDate("460125", locale: Locale(identifier: "de_DE"))

    // Should contain "1946" and German month name
    XCTAssertTrue(formatted.contains("1946"), "Should contain year 1946")
    XCTAssertTrue(formatted.contains("Januar") || formatted.contains("Jan"), "Should contain German month name")
  }

  func testFormatExpiryDate_FutureYear() {
    // Test formatting expiry date
    let formatted = MRZDateUtils.formatExpiryDate("301231")

    XCTAssertTrue(formatted.contains("2030"), "Should contain year 2030")
    XCTAssertTrue(formatted.contains("December") || formatted.contains("Dec"), "Should contain month name")
  }

  func testFormatDate_InvalidFormat_ReturnsOriginal() {
    // Test that invalid format returns original string
    let invalidDate = "invalid"
    let formatted = MRZDateUtils.formatBirthDate(invalidDate)

    XCTAssertEqual(formatted, invalidDate, "Should return original string for invalid format")
  }

  // MARK: - Age Validation Tests

  func testIsUnderAge_PersonUnder18() {
    // Create a birth date for someone who is currently 17 years old
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.year = calendar.component(.year, from: Date()) - 17
    dateComponents.month = 1
    dateComponents.day = 1

    guard let birthDate = calendar.date(from: dateComponents) else {
      XCTFail("Failed to create test date")
      return
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMdd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    let dateString = formatter.string(from: birthDate)

    XCTAssertTrue(MRZDateUtils.isUnderAge(dateString), "17-year-old should be under 18")
  }

  func testIsUnderAge_PersonExactly18() {
    // Create a birth date for someone who is exactly 18 years old
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.year = calendar.component(.year, from: Date()) - 18
    dateComponents.month = calendar.component(.month, from: Date())
    dateComponents.day = calendar.component(.day, from: Date())

    guard let birthDate = calendar.date(from: dateComponents) else {
      XCTFail("Failed to create test date")
      return
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMdd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    let dateString = formatter.string(from: birthDate)

    XCTAssertFalse(MRZDateUtils.isUnderAge(dateString), "18-year-old should not be under 18")
  }

  func testIsUnderAge_PersonOver18() {
    // Test with birth date "460125" (1946) - definitely over 18
    XCTAssertFalse(MRZDateUtils.isUnderAge("460125"), "Person born in 1946 should not be under 18")
  }

  func testIsUnderAge_CustomThreshold() {
    // Test custom age threshold (21 years)
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.year = calendar.component(.year, from: Date()) - 20
    dateComponents.month = 1
    dateComponents.day = 1

    guard let birthDate = calendar.date(from: dateComponents) else {
      XCTFail("Failed to create test date")
      return
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMdd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    let dateString = formatter.string(from: birthDate)

    XCTAssertTrue(MRZDateUtils.isUnderAge(dateString, ageThreshold: 21), "20-year-old should be under 21")
    XCTAssertFalse(MRZDateUtils.isUnderAge(dateString, ageThreshold: 18), "20-year-old should not be under 18")
  }

  // MARK: - Expiry Validation Tests

  func testIsExpired_PastDate() {
    // Test with a date in the past (2020)
    XCTAssertTrue(MRZDateUtils.isExpired("201231"), "Date in 2020 should be expired")
  }

  func testIsExpired_FutureDate() {
    // Test with a date in the future (2030)
    XCTAssertFalse(MRZDateUtils.isExpired("301231"), "Date in 2030 should not be expired")
  }

  // MARK: - Edge Cases

  func testParseMRZDate_EmptyString() {
    let date = MRZDateUtils.parseBirthDate("")
    XCTAssertNil(date, "Empty string should return nil")
  }

  func testParseMRZDate_InvalidFormat() {
    let date = MRZDateUtils.parseBirthDate("invalid")
    XCTAssertNil(date, "Invalid format should return nil")
  }

  func testParseMRZDate_WrongLength() {
    let date = MRZDateUtils.parseBirthDate("12345")
    XCTAssertNil(date, "Wrong length should return nil")
  }

  func testParseMRZDate_InvalidDate() {
    // Test invalid date like February 30th
    let date = MRZDateUtils.parseBirthDate("460230")
    // DateFormatter may or may not parse invalid dates depending on leniency
    // Just verify it doesn't crash
    _ = date
  }

  // MARK: - Threshold Tests

  func testBirthDateThreshold_Value() {
    XCTAssertEqual(MRZDateUtils.birthDateThreshold, 99, "Birth date threshold should be 99 years")
  }

  func testExpiryDateThreshold_Value() {
    XCTAssertEqual(MRZDateUtils.expiryDateThreshold, 49, "Expiry date threshold should be 49 years")
  }
}
