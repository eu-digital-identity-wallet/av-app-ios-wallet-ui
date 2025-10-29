import XCTest
@testable import feature_issuance
@testable import mrz_reader

final class MRZKeyExtractorTests: XCTestCase {

  // MARK: - Check Digit Calculation Tests

  func testCalculateCheckDigit_WithNumericString() {
    let result = MRZKeyExtractor.calculateCheckDigit("1234567")
    XCTAssertEqual(result, 4)
  }

  func testCalculateCheckDigit_WithAlphabeticString() {
    let result = MRZKeyExtractor.calculateCheckDigit("ABC")
    XCTAssertEqual(result, 5)
  }

  func testCalculateCheckDigit_WithFillers() {
    let result = MRZKeyExtractor.calculateCheckDigit("AB12<<<<<")
    XCTAssertEqual(result, 8)
  }

  func testCalculateCheckDigit_EmptyString() {
    let result = MRZKeyExtractor.calculateCheckDigit("")
    XCTAssertEqual(result, 0)
  }

  // MARK: - MRZ Key Extraction Tests (TD3 Format)

  func testExtractMRZKey_TD3Format_ValidPassport() {
    let mrzData = MRZData(
      documentType: "P",
      documentNumber: "AB1234567",
      issuingCountry: "USA",
      surname: "SMITH",
      givenNames: "JOHN",
      nationality: "USA",
      dateOfBirth: "900101",
      sex: "M",
      expirationDate: "301231",
      personalNumber: "",
      rawMRZ: "P<USASMITH<<JOHN<<<<<<<<<<<<<<<<<<<<<<<<<<<<\nAB12345674USA9001011M3012317<<<<<<<<<<<<<<04",
      mrzType: .td3
    )

    let result = MRZKeyExtractor.extractMRZKey(from: mrzData)
    XCTAssertEqual(result, "AB123456749001011M3012317")
  }

  func testExtractMRZKey_TD3Format_WithFillers() {
    let mrzData = MRZData(
      documentType: "P",
      documentNumber: "AB1234",
      issuingCountry: "GER",
      surname: "MÜLLER",
      givenNames: "ANNA",
      nationality: "GER",
      dateOfBirth: "850315",
      sex: "F",
      expirationDate: "351231",
      personalNumber: "",
      rawMRZ: "P<GERMÜLLER<<ANNA<<<<<<<<<<<<<<<<<<<<<<<<<<\nAB1234<<<1GER8503159F3512318<<<<<<<<<<<<<<06",
      mrzType: .td3
    )

    let result = MRZKeyExtractor.extractMRZKey(from: mrzData)
    XCTAssertEqual(result, "AB1234<<<18503159F3512318")
  }

  // MARK: - MRZ Key Extraction Tests (Fallback)

  func testExtractMRZKey_Fallback_WhenInvalidFormat() {
    let mrzData = MRZData(
      documentType: "P",
      documentNumber: "AB123456",
      issuingCountry: "USA",
      surname: "SMITH",
      givenNames: "JOHN",
      nationality: "USA",
      dateOfBirth: "900101",
      sex: "M",
      expirationDate: "301231",
      personalNumber: "",
      rawMRZ: "INVALID",
      mrzType: .td3
    )

    let result = MRZKeyExtractor.extractMRZKey(from: mrzData)
    XCTAssertTrue(result.hasPrefix("AB123456<"))
    XCTAssertEqual(result.count, 24)
  }

  func testExtractMRZKey_Fallback_ShortDocumentNumber() {
    let mrzData = MRZData(
      documentType: "P",
      documentNumber: "AB123",
      issuingCountry: "FRA",
      surname: "DUPONT",
      givenNames: "MARIE",
      nationality: "FRA",
      dateOfBirth: "950601",
      sex: "F",
      expirationDate: "280531",
      personalNumber: "",
      rawMRZ: "INVALID",
      mrzType: .td3
    )

    let result = MRZKeyExtractor.extractMRZKey(from: mrzData)
    XCTAssertTrue(result.hasPrefix("AB123<<<<"))
    XCTAssertEqual(result.count, 24)
  }

  func testExtractMRZKey_NonTD3Format_UsesFallback() {
    let mrzData = MRZData(
      documentType: "I",
      documentNumber: "CD789012",
      issuingCountry: "CAN",
      surname: "BROWN",
      givenNames: "DAVID",
      nationality: "CAN",
      dateOfBirth: "880912",
      sex: "M",
      expirationDate: "321015",
      personalNumber: "",
      rawMRZ: "IDCANCD789012<<<<<<<<<<<<<<<<<\n8809128M3210159<<<<<<<<<<<<<<",
      mrzType: .td1
    )

    let result = MRZKeyExtractor.extractMRZKey(from: mrzData)
    XCTAssertTrue(result.hasPrefix("CD789012<"))
    XCTAssertEqual(result.count, 24)
  }

  // MARK: - Edge Cases

  func testExtractMRZKey_EmptyDocumentNumber() {
    let mrzData = MRZData(
      documentType: "P",
      documentNumber: "",
      issuingCountry: "USA",
      surname: "TEST",
      givenNames: "USER",
      nationality: "USA",
      dateOfBirth: "000101",
      sex: "M",
      expirationDate: "991231",
      personalNumber: "",
      rawMRZ: "INVALID",
      mrzType: .td3
    )

    let result = MRZKeyExtractor.extractMRZKey(from: mrzData)
    XCTAssertTrue(result.hasPrefix("<<<<<<<<<"))
  }

  func testExtractMRZKey_LongDocumentNumber() {
    let mrzData = MRZData(
      documentType: "P",
      documentNumber: "ABCDEFGHIJ",
      issuingCountry: "USA",
      surname: "TEST",
      givenNames: "USER",
      nationality: "USA",
      dateOfBirth: "000101",
      sex: "M",
      expirationDate: "991231",
      personalNumber: "",
      rawMRZ: "INVALID",
      mrzType: .td3
    )

    let result = MRZKeyExtractor.extractMRZKey(from: mrzData)
    XCTAssertTrue(result.hasPrefix("ABCDEFGHI"))
  }
}
