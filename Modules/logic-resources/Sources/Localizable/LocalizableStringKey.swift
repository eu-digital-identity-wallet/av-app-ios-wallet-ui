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
import SwiftUI

public enum LocalizableStringKey: Equatable, Sendable {
  case dynamic(key: String)
  case custom(String)
  case space
  case search
  case genericErrorTitle
  case genericErrorDesc
  case biometryOpenSettings
  case biometryConfirmRequest
  case invalidQuickPin
  case tryAgain
  case shareButton
  case cancelButton
  case requestDataCaption
  case requestDataInfoNotice
  case requestDataTitle([String])
  case documentAdded
  case requestDataSheetCaption
  case okButton
  case shareDataReview
  case success
  case successfullySharedFollowingInformation
  case incompleteRequestDataSelection
  case addDoc
  case filters
  case sortByIssuedDateSectionTitle
  case showResults
  case welcomeBack([String])
  case viewDocumentDetails
  case pleaseWait
  case requestDataShareQuickPinCaption
  case requestDataShareBiometryCaption
  case addDocumentTitle
  case addDocumentSubtitle
  case addDocumentRequest
  case proximityConnectivityCaption
  case unavailableField
  case requestDataVerifiedEntity
  case requestDataVerifiedEntityMessage
  case changeQuickPinOption
  case quickPinSetTitle
  case quickPinEnterPin
  case quickPinConfirmPin
  case quickPinSetCaptionOne
  case quickPinSetCaptionTwo
  case quickPinNextButton
  case quickPinConfirmButton
  case quickPinSetSuccess
  case loginTitle
  case loginCaptionQuickPinOnly
  case loginCaption
  case quickPinSetSuccessButton
  case quickPinDoNotMatch
  case quickPinUpdateTitle
  case quickPinUpdateCaptionOne
  case quickPinUpdateCaptionTwo
  case quickPinUpdateCaptionThree
  case quickPinUpdateSuccess
  case quickPinUpdateSuccessButton
  case quickPinUpdateCancellationTitle
  case quickPinUpdateCancellationCaption
  case quickPinUpdateCancellationContinue
  case successTitlePunctuated
  case issuerWantWalletAddition
  case unknownVerifier
  case unknownIssuer
  case genericIssuer
  case filterByIssuer
  case yes
  case no
  case scanQrCode
  case signDocument
  case signDocumentSubtitle
  case selectDocument
  case validUntil([String])
  case bleDisabledModalTitle
  case bleDisabledModalCaption
  case bleDisabledModalButton
  case requestDataNoDocument
  case issuanceDetailsDeletionTitle([String])
  case deleteDocument
  case issuanceDetailsDeletionCaption([String])
  case errorUnableFetchDocuments
  case errorUnableFetchDocument
  case scannerQrTitleIssuing
  case scannerQrTitlePresentation
  case scannerQrCaptionIssuing
  case scannerQrCaptionPresentation
  case scannerQrTitle
  case scannerQrCaption
  case cameraError
  case missingPid
  case requestCredentialOfferTitle([String])
  case requestCredentialOfferNoDocument
  case unableToIssueAndStore
  case missingMetadata
  case issueButton
  case issuanceCodeTitle([String])
  case issuanceCodeCaption([String])
  case transactionCodeFormatError([String])
  case inProgress
  case scopedIssuanceSuccessDeferredCaption
  case scopedIssuanceSuccessDeferredCaptionDocName([String])
  case scopedIssuanceSuccessDeferredCaptionDocNameAndIssuer([String])
  case issuanceSuccessDeferredCaption([String])
  case pending
  case issuanceFailed
  case deferredDocumentsIssuedModalTitle
  case defferedDocumentsIssuedModalCaption
  case retrieveLogs
  case qrScanInformativeText
  case unableToPresentAndShare
  case itemNotFoundInStorage
  case itemsNotFoundInStorage
  case home
  case documents
  case transactions
  case authenticateAuthoriseTransactions
  case electronicallySignDigitalDocuments
  case learnMore
  case chooseFromList
  case chooseFromListTitle

  // Settings
  case settingsSupport
  case settingsUnlockWithBiometrics
  case settingsLanguage
  case settingsDeleteAllProofsOfAttestation
  case settingsTermsOfService
  case settingsAboutThisApp

  case addDocumentsToWallet
  case details
  case dataSharingRequest
  case dataShared
  case doneButton
  case dataSharingTitle
  case close
  case reset
  case all
  case descending
  case ascending
  case trustedRelyingParty
  case trustedRelyingPartyDescription
  case alertAccessOnlineServices
  case alertAccessOnlineServicesMessage
  case alertSignDocumentsSafely
  case alertSignDocumentsSafelyMessage
  case authenticate
  case inPerson
  case online
  case savedToFavorites
  case succesfullyAddedFollowingToWallet
  case removedFromFavorites
  case savedToFavoritesMessage
  case removedFromFavoritesMessages
  case viewDetails
  case requestsTheFollowing
  case walletIsSecured
  case noResults
  case noResultsDocumentsDescription
  case noResultsTransactionsDescription
  case proximityConnectionBleDescription
  case selectExpiryPeriod
  case filterByState
  case sortBy
  case deleteDocumentConfirmDialog
  case defaultLabel
  case valid
  case revoke
  case expired
  case dateIssued
  case expiryDate
  case nextSevenDays
  case nextThirtyDays
  case beyondThiryDays
  case beforeToday
  case issuanceRequest
  case myEuWallet
  case categoryGovernment
  case categoryHealth
  case categoryEducation
  case categoryFinance
  case categoryRetail
  case categoryOther
  case categorySocialSecurity
  case categoryTravel
  case changelog
  case orderBy
  case filterByCategory
  case searchDocuments
  case searchTransactions
  case filterByStatus
  case completed
  case failed
  case filterByDate
  case startDate
  case endDate
  case relyingParty
  case signedDocuments
  case transactionInformation
  case transactionDetailsDataShare
  case transactionDetailsDataSigned
  case transactionDetailsScreenCardDateLabel
  case transactionDetailsCompleted
  case or
  case today
  case thisWeek
  case unknownDate
  case minutesAgo([String])
  case minuteAgo([String])
  case transactionDate
  case filterByType
  case presentation
  case signing
  case issuance
  case withoutRelyingName
  case errorFetchTransactionLog
  case settings

  // splash screen
  case splashTitle
  case splashSponsorsTitle

  // feature-onboarding
  case onboardingStepWelcome
  case onboardingStepConsent
  case onboardoingStepPin
  case onboardingStepEnrollment

  // welcome step
  case welcomeTitle1
  case welcomePage1
  case welcomeTitle2
  case welcomePage2
  case welcomeTitle3
  case welcomePage3
  case welcomeSkipButton

  // Consent Step
  case consentTitle
  case consentCheckboxLabel1
  case consentCheckboxLabel2
  case consentCheckboxLabel3
  case consentHyperlinkLabel1
  case consentHyperlinkLabel2
  case consentConfirmButton

  // Pin Setup Step
  case quickPinCreateTitle
  case quickPinReEnterTitle
  case quickPinCreateSubtitle
  case quickPinReEnterSubtitle
  case quickPinTitle

  // Verification Step
  case verificationStepTitle
  case verificationStepDescription
  case verificationNationalId
  case verificationNationalIdDescription

  // Passport Enrollment
  case verificationPassport
  case verificationPassportDescription

  // Passport Enrollment Intro
  case passpostEnrollmentHeader
  case passpostEnrollmentTitle
  case passpostEnrollmentDescription
  case passportEnrollmentIntroStep1Description
  case passportEnrollmentIntroStep1Title
  case passportEnrollmentIntroStep2Description
  case passportEnrollmentIntroStep2Title
  case passportEnrollmentIntroStep3Description
  case passportEnrollmentIntroStep3Title
  case passportEnrollmentIntroStep4Title
  case passportEnrollmentIntroStep5Title
  case start

  // Passport Enrollment Instruction
  case passportEnrollmentIdentification
  case passportEnrollmentBiometrics
  case passportEnrollmentLiveVideo
  case takeAPhoto
  case passportEnrollmentInstructionHeader
  case passportEnrollmentInstructionBody1
  case passportEnrollmentInstructionPoint1
  case passportEnrollmentInstructionPoint2
  case passportEnrollmentInstructionBody2
  case passportCaptureDescription
  case processingDocument

  // Biometric Data reading
  case passportBiometricsFirstHeader
  case passportBiometricsFirstDescription
  case passportBiometricsFirstLink
  case passportBiometricsNext

  // Landing screen
  case landingScreenTitle
  case landingScreenbody
  case europeanUnionLabel1
  case credentialDetailsTitle
  case scanTitle
  case landingCredentialsLeft(Int)
  case addMoreCredentials

  // Biometric Setup
  case biometricSetupTitle
  case biometricSetupDescription(String)
  case biometricSetupButton
  case biometricSetupSkipButton

  // Settings
  case settingsAppInformation
  case settingsAppVersion
  case settingsCredentials
  case settingsDeleteCredentials

  //generic
  case back

  // Quick Pin ( BiometryView )
  case quickPinInvalidWithAttempts(Int)
  case quickPinInvalidLastAttempt
  case quickPinLockedOut
  case quickPinLockoutCountdownMinutes([Int])
  case quickPinLockoutCountdownSeconds(Int)
  case quickPinErrorInsecurePin

  // MRZ Scanner
  case mrzDocumentReady
  case mrzScanning
  case mrzPlaceDocumentInFrame
  case mrzCameraError
  case mrzCameraPermissionDenied
  case mrzCameraSetupFailed
  case mrzUnknownError
  case mrzInitializingCamera

  // MRZ Errors
  case mrzErrorInvalidData
  case mrzErrorDocumentExpired
  case mrzErrorProcessingFailed

  // Change Pin
  case changeQuickPinCaption
  case changePinDescription
  case changePinFirstPinDescription
  case changePinSecondPinDescription
  case changePinHelpText
  case changePinSuccessText

  // NFC Passport Reading
  case nfcReadyToScan
  case nfcInitializing
  case nfcReadingCOM
  case nfcReadingDG1
  case nfcReadingDG2
  case nfcReadingSOD
  case nfcReadingProgress
  case nfcReadingSuccess
  case nfcHoldSteady
  case nfcStartReading

  // NFC Errors
  case nfcErrorTagNotValid
  case nfcErrorMoreThanOneTag
  case nfcErrorConnection
  case nfcErrorUserCanceled
  case nfcErrorInvalidMRZKey
  case nfcErrorUnexpected
  case nfcErrorReadingFailed
  case nfcErrorMissingData

  // Passport Data Labels
  case passportBirthDate
  case passportExpiryDate
  case passportDocumentNumber
  case passportPhoto

  // Passport Data Display
  case passportDataReviewHeader
  case passportDataReviewDescription
  case passportIdCardTitle
  case continueButton

  // Liveness Check
  case livenessCheckHeader
  case livenessCheckDescription
  case livenessCheckInstructionPoint1
  case livenessCheckInstructionPoint2
  case livenessCheckFooter
  case livenessCheckStartButton
  case livenessCheckErrorReferenceImage
  case livenessCheckErrorNotLive
  case livenessCheckErrorNoMatch

  // Credential Issuance
  case credentialIssuanceTitle
  case credentialIssuanceDescription

  case incomplete
  case justNow
  case revoked
  case documentDetailsRevokedDocumentMessage
  case revokedModalTitle
  case revokedModalDescription
  case transactionDetailsRequestDeletionMessage
  case transactionDetailsRequestDeletionButton
  case transactionDetailsReportTransactionMessage
  case transactionDetailsReportTransactionButton
  case documentDetailsDocumentCredentialsText([String])
  case documentDetailsDocumentCredentialsMoreInfoText
  case documentDetailsDocumentCredentialsExpandedTextSubtitle
  case documentDetailsDocumentCredentialsExpandedButtonHideText
  case documentsListCredentialsUsageText([String])
  case expandableDocumentCredentialsIssueButton
  case issuanceAddDocumentNoOptions
  case unknown
}

public extension LocalizableStringKey {
  var toString: String {
    LocalizableManager.shared.get(with: self)
  }
  var toLocalizedStringKey: LocalizedStringKey {
    LocalizedStringKey(self.toString)
  }
}
