/*
 * Copyright (c) 2023 European Commission
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
import XCTest

@testable import logic_core
@testable import logic_test
@testable import feature_test
@testable import feature_common
@testable import feature_issuance
@testable import mrz_reader

final class TestDocumentMRZScanInteractor: EudiTest {

  var interactor: DocumentMRZScanInteractor!
  var walletKitController: MockWalletKitController!

  override func setUp() {
    super.setUp()
    self.walletKitController = MockWalletKitController()
    self.interactor = MRZDocumentScanInteractorImpl(
      walletController: walletKitController
    )
  }

  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
  }

  // MARK: - Valid MRZ Data Tests

  func testProcessMRZData_WhenValidData_ThenReturnsSuccessWithDocumentNumber() async {
    // Given
    let mrzData = createValidMRZData()

    // When
    let result = await interactor.processMRZData(mrzData: mrzData)

    // Then
    switch result {
    case .success(let documentId):
      XCTAssertEqual(documentId, "AB123456")
    case .failure:
      XCTFail("Expected success but got failure")
    }
  }

  // MARK: - Invalid MRZ Data Tests

  func testProcessMRZData_WhenEmptyDocumentNumber_ThenReturnsInvalidDataError() async {
    // Given
    let mrzData = createMRZDataWithEmptyDocumentNumber()

    // When
    let result = await interactor.processMRZData(mrzData: mrzData)

    // Then
    switch result {
    case .success:
      XCTFail("Expected failure but got success")
    case .failure(let error):
      XCTAssertEqual(error as? MRZError, MRZError.invalidData)
    }
  }

  func testProcessMRZData_WhenEmptySurname_ThenReturnsInvalidDataError() async {
    // Given
    let mrzData = createMRZDataWithEmptySurname()

    // When
    let result = await interactor.processMRZData(mrzData: mrzData)

    // Then
    switch result {
    case .success:
      XCTFail("Expected failure but got success")
    case .failure(let error):
      XCTAssertEqual(error as? MRZError, MRZError.invalidData)
    }
  }

  func testProcessMRZData_WhenEmptyIssuingCountry_ThenReturnsInvalidDataError() async {
    // Given
    let mrzData = createMRZDataWithEmptyIssuingCountry()

    // When
    let result = await interactor.processMRZData(mrzData: mrzData)

    // Then
    switch result {
    case .success:
      XCTFail("Expected failure but got success")
    case .failure(let error):
      XCTAssertEqual(error as? MRZError, MRZError.invalidData)
    }
  }

  func testProcessMRZData_WhenExpiredDocument_ThenReturnsInvalidDataError() async {
    // Given
    let mrzData = createExpiredMRZData()

    // When
    let result = await interactor.processMRZData(mrzData: mrzData)

    // Then
    switch result {
    case .success:
      XCTFail("Expected failure but got success")
    case .failure(let error):
      XCTAssertEqual(error as? MRZError, MRZError.invalidData)
    }
  }

  func testProcessMRZData_WhenAllFieldsEmpty_ThenReturnsInvalidDataError() async {
    // Given
    let mrzData = createEmptyMRZData()

    // When
    let result = await interactor.processMRZData(mrzData: mrzData)

    // Then
    switch result {
    case .success:
      XCTFail("Expected failure but got success")
    case .failure(let error):
      XCTAssertEqual(error as? MRZError, MRZError.invalidData)
    }
  }

  // MARK: - Edge Cases

  func testProcessMRZData_WhenExpirationDateIsToday_ThenReturnsInvalidDataError() async {
    // Given
    let mrzData = createMRZDataWithTodayExpiration()

    // When
    let result = await interactor.processMRZData(mrzData: mrzData)

    // Then
    switch result {
    case .success:
      XCTFail("Expected failure but got success")
    case .failure(let error):
      XCTAssertEqual(error as? MRZError, MRZError.invalidData)
    }
  }

  func testProcessMRZData_WhenExpirationDateIsTomorrow_ThenReturnsSuccess() async {
    // Given
    let mrzData = createMRZDataWithTomorrowExpiration()

    // When
    let result = await interactor.processMRZData(mrzData: mrzData)

    // Then
    switch result {
    case .success(let documentId):
      XCTAssertEqual(documentId, "AB123456")
    case .failure:
      XCTFail("Expected success but got failure")
    }
  }

  func testProcessMRZData_WhenInvalidExpirationDateFormat_ThenReturnsSuccess() async {
    // Given: Invalid date format should be treated as missing, document still valid
    let mrzData = createMRZDataWithInvalidDateFormat()

    // When
    let result = await interactor.processMRZData(mrzData: mrzData)

    // Then
    switch result {
    case .success(let documentId):
      XCTAssertEqual(documentId, "AB123456")
    case .failure:
      XCTFail("Expected success but got failure")
    }
  }
}

// MARK: - Test Data Helpers

private extension TestDocumentMRZScanInteractor {

  func createValidMRZData() -> MRZData {
    let futureDate = getFutureDateString(yearsFromNow: 5)
    return MRZData(
      documentType: "P",
      documentNumber: "AB123456",
      issuingCountry: "USA",
      surname: "SMITH",
      givenNames: "JOHN",
      nationality: "USA",
      dateOfBirth: "900101",
      sex: "M",
      expirationDate: futureDate,
      personalNumber: "",
      rawMRZ: "P<USASMITH<<JOHN<<<<<<<<<<<<<<<<<<<<<<<<<<<<\nAB1234567USA9001011M\(futureDate)<<<<<<<<<<<<<<04",
      mrzType: .td3
    )
  }

  func createMRZDataWithEmptyDocumentNumber() -> MRZData {
    let futureDate = getFutureDateString(yearsFromNow: 5)
    return MRZData(
      documentType: "P",
      documentNumber: "",
      issuingCountry: "USA",
      surname: "SMITH",
      givenNames: "JOHN",
      nationality: "USA",
      dateOfBirth: "900101",
      sex: "M",
      expirationDate: futureDate,
      personalNumber: "",
      rawMRZ: "P<USASMITH<<JOHN<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n",
      mrzType: .td3
    )
  }

  func createMRZDataWithEmptySurname() -> MRZData {
    let futureDate = getFutureDateString(yearsFromNow: 5)
    return MRZData(
      documentType: "P",
      documentNumber: "AB123456",
      issuingCountry: "USA",
      surname: "",
      givenNames: "JOHN",
      nationality: "USA",
      dateOfBirth: "900101",
      sex: "M",
      expirationDate: futureDate,
      personalNumber: "",
      rawMRZ: "P<USA<<JOHN<<<<<<<<<<<<<<<<<<<<<<<<<<<<\nAB1234567USA9001011M\(futureDate)<<<<<<<<<<<<<<04",
      mrzType: .td3
    )
  }

  func createMRZDataWithEmptyIssuingCountry() -> MRZData {
    let futureDate = getFutureDateString(yearsFromNow: 5)
    return MRZData(
      documentType: "P",
      documentNumber: "AB123456",
      issuingCountry: "",
      surname: "SMITH",
      givenNames: "JOHN",
      nationality: "USA",
      dateOfBirth: "900101",
      sex: "M",
      expirationDate: futureDate,
      personalNumber: "",
      rawMRZ: "P<SMITH<<JOHN<<<<<<<<<<<<<<<<<<<<<<<<<<<<\nAB1234567USA9001011M\(futureDate)<<<<<<<<<<<<<<04",
      mrzType: .td3
    )
  }

  func createExpiredMRZData() -> MRZData {
    return MRZData(
      documentType: "P",
      documentNumber: "AB123456",
      issuingCountry: "USA",
      surname: "SMITH",
      givenNames: "JOHN",
      nationality: "USA",
      dateOfBirth: "900101",
      sex: "M",
      expirationDate: "200101", // Expired in 2020
      personalNumber: "",
      rawMRZ: "P<USASMITH<<JOHN<<<<<<<<<<<<<<<<<<<<<<<<<<<<\nAB1234567USA9001011M200101<<<<<<<<<<<<<<04",
      mrzType: .td3
    )
  }

  func createMRZDataWithTodayExpiration() -> MRZData {
    let todayDateString = getTodayDateString()
    return MRZData(
      documentType: "P",
      documentNumber: "AB123456",
      issuingCountry: "USA",
      surname: "SMITH",
      givenNames: "JOHN",
      nationality: "USA",
      dateOfBirth: "900101",
      sex: "M",
      expirationDate: todayDateString,
      personalNumber: "",
      rawMRZ: "P<USASMITH<<JOHN<<<<<<<<<<<<<<<<<<<<<<<<<<<<\nAB1234567USA9001011M\(todayDateString)<<<<<<<<<<<<<<04",
      mrzType: .td3
    )
  }

  func createMRZDataWithTomorrowExpiration() -> MRZData {
    let tomorrowDateString = getTomorrowDateString()
    return MRZData(
      documentType: "P",
      documentNumber: "AB123456",
      issuingCountry: "USA",
      surname: "SMITH",
      givenNames: "JOHN",
      nationality: "USA",
      dateOfBirth: "900101",
      sex: "M",
      expirationDate: tomorrowDateString,
      personalNumber: "",
      rawMRZ: "P<USASMITH<<JOHN<<<<<<<<<<<<<<<<<<<<<<<<<<<<\nAB1234567USA9001011M\(tomorrowDateString)<<<<<<<<<<<<<<04",
      mrzType: .td3
    )
  }

  func createMRZDataWithInvalidDateFormat() -> MRZData {
    return MRZData(
      documentType: "P",
      documentNumber: "AB123456",
      issuingCountry: "USA",
      surname: "SMITH",
      givenNames: "JOHN",
      nationality: "USA",
      dateOfBirth: "900101",
      sex: "M",
      expirationDate: "INVALID",
      personalNumber: "",
      rawMRZ: "P<USASMITH<<JOHN<<<<<<<<<<<<<<<<<<<<<<<<<<<<\nAB1234567USA9001011MINVALID<<<<<<<<<<<<<<04",
      mrzType: .td3
    )
  }

  func createEmptyMRZData() -> MRZData {
    return MRZData(
      documentType: "",
      documentNumber: "",
      issuingCountry: "",
      surname: "",
      givenNames: "",
      nationality: "",
      dateOfBirth: "",
      sex: "",
      expirationDate: "",
      personalNumber: "",
      rawMRZ: "",
      mrzType: .unknown
    )
  }

  // MARK: - Date Helper Functions

  func getFutureDateString(yearsFromNow: Int) -> String {
    let calendar = Calendar.current
    let futureDate = calendar.date(byAdding: .year, value: yearsFromNow, to: Date())!
    return formatDateToMRZ(date: futureDate)
  }

  func getTodayDateString() -> String {
    return formatDateToMRZ(date: Date())
  }

  func getTomorrowDateString() -> String {
    let calendar = Calendar.current
    let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
    return formatDateToMRZ(date: tomorrow)
  }

  func formatDateToMRZ(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMdd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter.string(from: date)
  }
}
