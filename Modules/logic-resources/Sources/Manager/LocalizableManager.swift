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
import Foundation

protocol LocalizableManagerType: Sendable {
  static var shared: LocalizableManagerType { get }
  func get(with key: LocalizableStringKey) -> String
}

final class LocalizableManager: LocalizableManagerType {

  static let shared: LocalizableManagerType = LocalizableManager()

  private let bundle: Bundle

  private init() {
    self.bundle = .assetsBundle
  }

  func get(with key: LocalizableStringKey) -> String {
    return switch key {
    case .dynamic(let key):
      bundle.localizedString(forKey: key)
    case .custom(let literal):
      literal
    case .search:
      bundle.localizedString(forKey: "search")
    case .genericErrorTitle:
      bundle.localizedString(forKey: "generic_error_title")
    case .genericErrorDesc:
      bundle.localizedString(forKey: "generic_error_description")
    case .biometryOpenSettings:
      bundle.localizedString(forKey: "biometry_open_settings")
    case .invalidQuickPin:
      bundle.localizedString(forKey: "invalid_quick_pin")
    case .tryAgain:
      bundle.localizedString(forKey: "try_again")
    case .shareButton:
      bundle.localizedString(forKey: "share_button")
    case .cancelButton:
      bundle.localizedString(forKey: "cancel_button")
    case .requestDataInfoNotice:
      bundle.localizedString(forKey: "request_data_info_notice")
    case .requestDataTitle(let args):
      bundle.localizedStringWithArguments(forKey: "request_data_share_title", arguments: args)
    case .documentAdded:
      bundle.localizedString(forKey: "document_added")
    case .requestDataSheetCaption:
      bundle.localizedString(forKey: "request_data_sheet_caption")
    case .okButton:
      bundle.localizedString(forKey: "ok_button")
    case .shareDataReview:
      bundle.localizedString(forKey: "share_data_review_title")
    case .success:
      bundle.localizedString(forKey: "success")
    case .successfullySharedFollowingInformation:
      bundle.localizedString(forKey: "successfully_shared_following_information")
    case .incompleteRequestDataSelection:
      bundle.localizedString(forKey: "incomplete_request_data_selecting")
    case .addDoc:
      bundle.localizedString(forKey: "add_doc")
    case .pleaseWait:
      bundle.localizedString(forKey: "please_wait")
    case .requestDataShareQuickPinCaption:
      bundle.localizedString(forKey: "request_data_share_quick_pin_caption")
    case .requestDataShareBiometryCaption:
      bundle.localizedString(forKey: "request_data_share_biometry_caption")
    case .addDocumentTitle:
      bundle.localizedString(forKey: "add_document_title")
    case .addDocumentRequest:
      bundle.localizedString(forKey: "add_document_request")
    case .addDocumentSubtitle:
      bundle.localizedString(forKey: "add_document_subtitle")
    case .requestDataVerifiedEntity:
      bundle.localizedString(forKey: "request_data_verified_entity")
    case .requestDataVerifiedEntityMessage:
      bundle.localizedString(forKey: "request_data_verified_entity_message")
    case .changeQuickPinOption:
      bundle.localizedString(forKey: "change_quick_pin_option")
    case .quickPinSetTitle:
      bundle.localizedString(forKey: "quick_pin_set_title")
    case .quickPinSetCaptionOne:
      bundle.localizedString(forKey: "quick_pin_set_step_one_caption")
    case .quickPinSetCaptionTwo:
      bundle.localizedString(forKey: "quick_pin_set_step_two_caption")
    case .quickPinNextButton:
      bundle.localizedString(forKey: "quick_pin_next_button")
    case .quickPinConfirmButton:
      bundle.localizedString(forKey: "quick_pin_confirm_button")
    case .quickPinSetSuccess:
      bundle.localizedString(forKey: "quick_pin_set_success")
    case .loginTitle:
      bundle.localizedString(forKey: "login_title")
    case .loginCaptionQuickPinOnly:
      bundle.localizedString(forKey: "login_caption_quick_pin_only")
    case .loginCaption:
      bundle.localizedString(forKey: "login_caption")
    case .quickPinSetSuccessButton:
      bundle.localizedString(forKey: "quick_pin_set_success_button")
    case .quickPinDoNotMatch:
      bundle.localizedString(forKey: "quick_pin_dont_match")
    case .quickPinUpdateTitle:
      bundle.localizedString(forKey: "quick_pin_update_title")
    case .quickPinUpdateCaptionOne:
      bundle.localizedString(forKey: "quick_pin_update_step_one_caption")
    case .quickPinUpdateCaptionTwo:
      bundle.localizedString(forKey: "quick_pin_update_step_two_caption")
    case .quickPinUpdateCaptionThree:
      bundle.localizedString(forKey: "quick_pin_update_step_three_caption")
    case .quickPinUpdateSuccess:
      bundle.localizedString(forKey: "quick_pin_update_success")
    case .quickPinUpdateSuccessButton:
      bundle.localizedString(forKey: "quick_pin_update_success_button")
    case .quickPinUpdateCancellationTitle:
      bundle.localizedString(forKey: "quick_pin_update_cancellation_title")
    case .quickPinUpdateCancellationCaption:
      bundle.localizedString(forKey: "quick_pin_update_cancellation_caption")
    case .quickPinUpdateCancellationContinue:
      bundle.localizedString(forKey: "quick_pin_update_cancellation_continue")
    case .unknownVerifier:
      bundle.localizedString(forKey: "unknown_verifier")
    case .unknownIssuer:
      bundle.localizedString(forKey: "unknown_issuer")
    case .scanQrCode:
      bundle.localizedString(forKey: "scan_qr_code")
    case .requestDataNoDocument:
      bundle.localizedString(forKey: "request_data_no_document")
    case .deleteDocument:
      bundle.localizedString(forKey: "delete_document")
    case .errorUnableFetchDocuments:
      bundle.localizedString(forKey: "error_unable_fetch_documents")
    case .errorUnableFetchDocument:
      bundle.localizedString(forKey: "error_unable_fetch_document")
    case .cameraError:
      bundle.localizedString(forKey: "camera_error")
    case .missingPid:
      bundle.localizedString(forKey: "missing_pid")
    case .requestCredentialOfferTitle(let args):
      bundle.localizedStringWithArguments(forKey: "request_credential_offer_title", arguments: args)
    case .requestCredentialOfferNoDocument:
      bundle.localizedString(forKey: "request_credential_offer_no_document")
    case .unableToIssueAndStore:
      bundle.localizedString(forKey: "unable_to_issue_and_store_documents")
    case .issueButton:
      bundle.localizedString(forKey: "issue_button")
    case .issuanceCodeTitle(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_code_title", arguments: args)
    case .issuanceCodeCaption(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_code_caption", arguments: args)
    case .transactionCodeFormatError(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_code_format_error", arguments: args)
    case .inProgress:
      bundle.localizedString(forKey: "in_progress")
    case .scopedIssuanceSuccessDeferredCaption:
      bundle.localizedString(forKey: "scoped_issuance_success_deferred_caption")
    case .scopedIssuanceSuccessDeferredCaptionDocName(let args):
      bundle.localizedStringWithArguments(forKey: "scoped_issuance_success_deferred_caption_docname", arguments: args)
    case .scopedIssuanceSuccessDeferredCaptionDocNameAndIssuer(let args):
      bundle.localizedStringWithArguments(forKey: "scoped_issuance_success_deferred_caption_docname_and_issuer_name", arguments: args)
    case .issuanceSuccessDeferredCaption(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_success_deferred_caption", arguments: args)
    case .pending:
      bundle.localizedString(forKey: "pending")
    case .retrieveLogs:
      bundle.localizedString(forKey: "retrieve_logs")
    case .qrScanInformativeText:
      bundle.localizedString(forKey: "qr_scan_informative_text")
    case .unableToPresentAndShare:
      bundle.localizedString(forKey: "error_unable_present_documents")
    case .itemNotFoundInStorage:
      bundle.localizedString(forKey: "item_not_found_in_storage")
    case .itemsNotFoundInStorage:
      bundle.localizedString(forKey: "items_not_found_in_storage")
    case .authenticateAuthoriseTransactions:
      bundle.localizedString(forKey: "authenticate_authorise_transactions")
    case .learnMore:
      bundle.localizedString(forKey: "learn_more")
    case .details:
      bundle.localizedString(forKey: "details")
    case .dataSharingRequest:
      bundle.localizedString(forKey: "data_sharing_request")
    case .dataShared:
      bundle.localizedString(forKey: "data_shared")
    case .doneButton:
      bundle.localizedString(forKey: "done_button")
    case .dataSharingTitle:
      bundle.localizedString(forKey: "data_sharing_title")
    case .close:
      bundle.localizedString(forKey: "close")
    case .trustedRelyingParty:
      bundle.localizedString(forKey: "trusted_relying_party")
    case .trustedRelyingPartyDescription:
      bundle.localizedString(forKey: "trusted_relying_party_description")
    case .issuerWantWalletAddition:
      bundle.localizedString(forKey: "issuer_want_wallet_addition")
    case .scannerQrTitleIssuing:
      bundle.localizedString(forKey: "scanner_qr_title_issuing")
    case .scannerQrTitlePresentation:
      bundle.localizedString(forKey: "scanner_qr_title_presentation")
    case .scannerQrCaptionIssuing:
      bundle.localizedString(forKey: "scanner_qr_caption_issuing")
    case .scannerQrCaptionPresentation:
      bundle.localizedString(forKey: "scanner_qr_caption_presentation")
    case .quickPinEnterPin:
      bundle.localizedString(forKey: "quick_pin_enter_a_pin")
    case .quickPinConfirmPin:
      bundle.localizedString(forKey: "quick_pin_confirm_pin")
    case .biometryConfirmRequest:
      bundle.localizedString(forKey: "biometry_confirm_request")
    case .viewDetails:
      bundle.localizedString(forKey: "view_details")
    case .requestsTheFollowing:
      bundle.localizedString(forKey: "requests_the_following")
    case .noResults:
      bundle.localizedString(forKey: "no_results")
    case .noResultsDocumentsDescription:
      bundle.localizedString(forKey: "no_results_documents_description")
    case .deleteDocumentConfirmDialog:
      bundle.localizedString(forKey: "delete_document_confirm_dialog")
    case .valid:
      bundle.localizedString(forKey: "valid")
    case .issuanceRequest:
      bundle.localizedString(forKey: "issuance_request")
    case .categoryGovernment:
      bundle.localizedString(forKey: "category_government")
    case .categoryHealth:
      bundle.localizedString(forKey: "category_health")
    case .categoryEducation:
      bundle.localizedString(forKey: "category_education")
    case .categoryFinance:
      bundle.localizedString(forKey: "category_finance")
    case .categoryRetail:
      bundle.localizedString(forKey: "category_retail")
    case .categoryOther:
      bundle.localizedString(forKey: "category_other")
    case .categorySocialSecurity:
      bundle.localizedString(forKey: "category_social_security")
    case .categoryTravel:
      bundle.localizedString(forKey: "category_travel")
    case .changelog:
      bundle.localizedString(forKey: "changelog")
    case .failed:
      bundle.localizedString(forKey: "failed")
    case .or:
      bundle.localizedString(forKey: "or")
    case .errorFetchTransactionLog:
      bundle.localizedString(forKey: "fetch_error_transaction_log")
    case .settings:
      bundle.localizedString(forKey: "settings_menu")
    case .splashTitle:
        bundle.localizedString(forKey: "splash_title")
    case .splashSponsorsTitle:
        bundle.localizedString(forKey: "splash_sponsors_title")
    case .welcomeTitle1:
        bundle.localizedString(forKey: "welcome_title_1")
    case .welcomePage1:
        bundle.localizedString(forKey: "welcome_page_1")
    case .welcomeTitle2:
        bundle.localizedString(forKey: "welcome_title_2")
    case .welcomePage2:
        bundle.localizedString(forKey: "welcome_page_2")
    case .welcomeTitle3:
        bundle.localizedString(forKey: "welcome_title_3")
    case .welcomePage3:
        bundle.localizedString(forKey: "welcome_page_3")
    case .welcomeSkipButton:
        bundle.localizedString(forKey: "welcome_screen_skip")
    case .onboardingStepWelcome:
        bundle.localizedString(forKey: "onboarding_step_1_title")
    case .onboardingStepConsent:
        bundle.localizedString(forKey: "onboarding_step_2_title")
    case .onboardoingStepPin:
        bundle.localizedString(forKey: "onboarding_step_3_title")
    case .onboardingStepEnrollment:
        bundle.localizedString(forKey: "onboarding_step_4_title")
    case .consentTitle:
        bundle.localizedString(forKey: "consent_title")
    case .consentCheckboxLabel1:
        bundle.localizedString(forKey: "consent_checkbox_label_1")
    case .consentCheckboxLabel2:
        bundle.localizedString(forKey: "consent_checkbox_label_2")
    case .consentHyperlinkLabel1:
        bundle.localizedString(forKey: "consent_hyperlink_label_1")
    case .consentHyperlinkLabel2:
        bundle.localizedString(forKey: "consent_hyperlink_label_2")
    case .consentConfirmButton:
        bundle.localizedString(forKey: "consent_screen_confirm_button")
    case .quickPinCreateTitle:
        bundle.localizedString(forKey: "quick_pin_create_title")
    case .quickPinReEnterTitle:
        bundle.localizedString(forKey: "quick_pin_create_reenter_title")
    case .quickPinCreateSubtitle:
        bundle.localizedString(forKey: "quick_pin_create_enter_subtitle")
    case .quickPinReEnterSubtitle:
        bundle.localizedString(forKey: "quick_pin_create_reenter_subtitle")
    case .verificationStepTitle:
        bundle.localizedString(forKey: "onboarding_verification_title")
    case .verificationStepDescription:
        bundle.localizedString(forKey: "onboarding_verification_description")
    case .verificationNationalId:
        bundle.localizedString(forKey: "onboarding_verification_national_id")
    case .verificationNationalIdDescription:
        bundle.localizedString(forKey: "onboarding_verification_national_id_description")
    case .verificationPassport:
        bundle.localizedString(forKey: "onboarding_verification_passport_id")
    case .verificationPassportDescription:
      bundle.localizedString(forKey: "onboarding_verification_passport_description")
    case .passpostEnrollmentHeader:
      bundle.localizedString(forKey: "passpost_enrollment_header")
    case .passpostEnrollmentTitle:
      bundle.localizedString(forKey: "passpost_enrollment_title")
    case .passpostEnrollmentDescription:
      bundle.localizedString(forKey: "passpost_enrollment_description")
    case .landingScreenTitle:
        bundle.localizedString(forKey: "landing_screen_title")
    case .landingScreenbody:
        bundle.localizedString(forKey: "landing_screen_body")
    case .europeanUnionLabel1:
        bundle.localizedString(forKey: "european_union_label_1")
    case .credentialDetailsTitle:
        bundle.localizedString(forKey: "credential_details_title")
    case .scanTitle:
        bundle.localizedString(forKey: "scan_title")
    case .biometricSetupTitle:
        bundle.localizedString(forKey: "biometric_setup_title")
    case .biometricSetupDescription(let arg):
        bundle.localizedStringWithArguments(forKey: "biometric_setup_description", arguments: [arg])
    case .biometricSetupButton:
        bundle.localizedString(forKey: "biometric_setup_enable")
    case .biometricSetupSkipButton:
        bundle.localizedString(forKey: "biometric_setup_skip")
    case .landingCredentialsLeft(let arg):
        bundle.localizedStringWithArguments(forKey: "landing_screen_credentials_left", arguments: [arg])
    case .addMoreCredentials:
        bundle.localizedString(forKey: "landing_screen_add_more")
    case .settingsAppInformation:
        bundle.localizedString(forKey: "settings_app_information")
    case .settingsAppVersion:
        bundle.localizedString(forKey: "settings_app_version")
    case .settingsCredentials:
        bundle.localizedString(forKey: "settings_credentials")
    case .settingsDeleteCredentials:
        bundle.localizedString(forKey: "settings_delete_credentials")
    case .back:
      bundle.localizedString(forKey: "back_button_title")
    case .startProcedure:
      bundle.localizedString(forKey: "start_procedure")
    case .passportEnrollmentIdentification:
      bundle.localizedString(forKey: "passport_enrollment_step1_title")
    case .passportEnrollmentBiometrics:
      bundle.localizedString(forKey: "passport_enrollment_step2_title")
    case .passportEnrollmentLiveVideo:
      bundle.localizedString(forKey: "passport_enrollment_step3_title")
    case .takeAPhoto:
      bundle.localizedString(forKey: "take_a_photo_button_title")
    case .passportEnrollmentIntroStep1Description:
      bundle.localizedString(forKey: "passport_enrollment_intro_step1_description")
    case .passportEnrollmentIntroStep1Title:
      bundle.localizedString(forKey: "passport_enrollment_intro_step1_title")
    case .passportEnrollmentIntroStep2Description:
      bundle.localizedString(forKey: "passport_enrollment_intro_step2_description")
    case .passportEnrollmentIntroStep2Title:
      bundle.localizedString(forKey: "passport_enrollment_intro_step2_title")
    case .passportEnrollmentIntroStep3Description:
      bundle.localizedString(forKey: "passport_enrollment_intro_step3_description")
    case .passportEnrollmentIntroStep3Title:
      bundle.localizedString(forKey: "passport_enrollment_intro_step3_title")
    case .passportEnrollmentIntroStep4Title:
      bundle.localizedString(forKey: "passport_enrollment_intro_step4_title")
    case .passportEnrollmentIntroStep5Title:
      bundle.localizedString(forKey: "passport_enrollment_intro_step5_title")
    case .quickPinInvalidWithAttempts(let arg):
        bundle.localizedStringWithArguments(forKey: "quick_pin_invalid_with_attempts", arguments: [arg])
    case .quickPinInvalidLastAttempt:
        bundle.localizedString(forKey: "quick_pin_invalid_last_attempt")
    case .quickPinLockedOut:
        bundle.localizedString(forKey: "quick_pin_locked_out")
    case .quickPinLockoutCountdownMinutes(let args):
        bundle.localizedStringWithArguments(forKey: "quick_pin_lockout_countdown_minutes", arguments: args)
    case .quickPinLockoutCountdownSeconds(let arg):
        bundle.localizedStringWithArguments(forKey: "quick_pin_lockout_countdown_seconds", arguments: [arg])
    case .quickPinErrorInsecurePin:
        bundle.localizedString(forKey: "quick_pin_error_insecure_pin")
    case .passportEnrollmentInstructionHeader:
      bundle.localizedString(forKey: "passport_enrollment_instruction_header")
    case .passportEnrollmentInstructionBody1:
      bundle.localizedString(forKey: "passport_enrollment_instruction_body1")
    case .passportEnrollmentInstructionPoint1:
      bundle.localizedString(forKey: "passport_enrollment_instruction_point1")
    case .passportEnrollmentInstructionPoint2:
      bundle.localizedString(forKey: "passport_enrollment_instruction_point2")
    case .passportEnrollmentInstructionBody2:
      bundle.localizedString(forKey: "passport_enrollment_instruction_body2")
    case .passportCaptureDescription:
      bundle.localizedString(forKey: "passport_capture_description")
    case .processingDocument:
      bundle.localizedString(forKey: "processing_document")
    case .mrzDocumentReady:
      bundle.localizedString(forKey: "mrz_document_ready")
    case .mrzScanning:
      bundle.localizedString(forKey: "mrz_scanning")
    case .mrzPlaceDocumentInFrame:
      bundle.localizedString(forKey: "mrz_place_document_in_frame")
    case .mrzCameraError:
      bundle.localizedString(forKey: "mrz_camera_error")
    case .mrzCameraPermissionDenied:
      bundle.localizedString(forKey: "mrz_camera_permission_denied")
    case .mrzCameraSetupFailed:
      bundle.localizedString(forKey: "mrz_camera_setup_failed")
    case .mrzUnknownError:
      bundle.localizedString(forKey: "mrz_unknown_error")
    case .mrzInitializingCamera:
      bundle.localizedString(forKey: "mrz_initializing_camera")
    case .mrzErrorInvalidData:
      bundle.localizedString(forKey: "mrz_error_invalid_data")
    case .mrzErrorDocumentExpired:
      bundle.localizedString(forKey: "mrz_error_document_expired")
    case .mrzErrorProcessingFailed:
      bundle.localizedString(forKey: "mrz_error_processing_failed")
    }
  }
}

fileprivate extension Bundle {
  func localizedString(forKey key: String) -> String {
    let localizedBundle = self.localizedBundle()
    return localizedBundle.localizedString(forKey: key, value: nil, table: nil)
  }

  func localizedStringWithArguments(forKey key: String, arguments: [CVarArg]) -> String {
    String(format: self.localizedString(forKey: key), locale: Locale.current, arguments: arguments)
  }

  private func localizedBundle() -> Bundle {
    let preferredLanguages = Locale.preferredLanguages
    let availableLocalizations = self.localizations

    let matchedLocalizations = Bundle.preferredLocalizations(from: availableLocalizations, forPreferences: preferredLanguages)

    if let preferredLanguage = matchedLocalizations.first,
       let path = self.path(forResource: preferredLanguage, ofType: "lproj"),
       let localizedBundle = Bundle(path: path) {
      return localizedBundle
    }
    return self
  }
}
