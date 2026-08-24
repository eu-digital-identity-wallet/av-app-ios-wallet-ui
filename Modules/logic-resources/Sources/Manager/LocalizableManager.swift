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
      case .space:
        " "
      case .ageOver18:
        bundle.localizedString(forKey: "age_over_18")
      case .ageOver(let arg1):
      bundle.localizedStringWithArguments(forKey: "age_over", arguments: [arg1])
      case .biometricConfirmRequest:
        bundle.localizedString(forKey: "biometric_confirm_request")
      case .biometricDefaultModeTextAbovePinField:
        bundle.localizedString(forKey: "biometric_default_mode_text_above_pin_field")
      case .biometricLoginBiometricsEnabledSubtitle:
        bundle.localizedString(forKey: "biometric_login_biometrics_enabled_subtitle")
      case .biometricLoginBiometricsNotEnabledSubtitle:
        bundle.localizedString(forKey: "biometric_login_biometrics_not_enabled_subtitle")
      case .biometricLoginForgotPin:
        bundle.localizedString(forKey: "biometric_login_forgot_pin")
      case .biometricLoginTitle:
        bundle.localizedString(forKey: "biometric_login_title")
      case .biometricNoHardware:
        bundle.localizedString(forKey: "biometric_no_hardware")
      case .biometricPromptSubtitle:
        bundle.localizedString(forKey: "biometric_prompt_subtitle")
      case .biometricPromptTitle:
        bundle.localizedString(forKey: "biometric_prompt_title")
      case .biometricSetupDescription(let arg1):
        bundle.localizedStringWithArguments(forKey: "biometric_setup_description", arguments: [arg1])
      case .biometricSetupEnable:
        bundle.localizedString(forKey: "biometric_setup_enable")
      case .biometricSetupSkip:
        bundle.localizedString(forKey: "biometric_setup_skip")
      case .biometricSetupTitle:
        bundle.localizedString(forKey: "biometric_setup_title")
      case .biometricUnknownError:
        bundle.localizedString(forKey: "biometric_unknown_error")
      case .biometryUnlockReason:
        bundle.localizedString(forKey: "biometry_unlock_reason")
      case .cdCloseButton:
        bundle.localizedString(forKey: "cd_close_button")
      case .cdFlashButton:
        bundle.localizedString(forKey: "cd_flash_button")
      case .confirmDocRemovalDialogDelete:
        bundle.localizedString(forKey: "confirm_doc_removal_dialog_delete")
      case .confirmDocRemovalDialogText:
        bundle.localizedString(forKey: "confirm_doc_removal_dialog_text")
      case .confirmDocRemovalDialogTitle:
        bundle.localizedString(forKey: "confirm_doc_removal_dialog_title")
      case .consentScreenConfirmButton:
        bundle.localizedString(forKey: "consent_screen_confirm_button")
      case .consentScreenDataProtectionButton:
        bundle.localizedString(forKey: "consent_screen_data_protection_button")
      case .consentScreenDataProtectionCheckbox:
        bundle.localizedString(forKey: "consent_screen_data_protection_checkbox")
      case .consentScreenPersonalDataCheckbox:
        bundle.localizedString(forKey: "consent_screen_personal_data_checkbox")
      case .consentScreenTitle:
        bundle.localizedString(forKey: "consent_screen_title")
      case .consentScreenTosButton:
        bundle.localizedString(forKey: "consent_screen_tos_button")
      case .consentScreenTosCheckbox:
        bundle.localizedString(forKey: "consent_screen_tos_checkbox")
      case .contentDescriptionAddDocumentFromQrIcon:
        bundle.localizedString(forKey: "content_description_add_document_from_qr_icon")
      case .contentDescriptionAddIcon:
        bundle.localizedString(forKey: "content_description_add_icon")
      case .contentDescriptionArrowBackIcon:
        bundle.localizedString(forKey: "content_description_arrow_back_icon")
      case .contentDescriptionArrowDownIcon:
        bundle.localizedString(forKey: "content_description_arrow_down_icon")
      case .contentDescriptionArrowRightIcon:
        bundle.localizedString(forKey: "content_description_arrow_right_icon")
      case .contentDescriptionArrowUpIcon:
        bundle.localizedString(forKey: "content_description_arrow_up_icon")
      case .contentDescriptionCheckIcon:
        bundle.localizedString(forKey: "content_description_check_icon")
      case .contentDescriptionClockTimerIcon:
        bundle.localizedString(forKey: "content_description_clock_timer_icon")
      case .contentDescriptionCloseIcon:
        bundle.localizedString(forKey: "content_description_close_icon")
      case .contentDescriptionDateRangeIcon:
        bundle.localizedString(forKey: "content_description_date_range_icon")
      case .contentDescriptionDocumentsIcon:
        bundle.localizedString(forKey: "content_description_documents_icon")
      case .contentDescriptionEditIcon:
        bundle.localizedString(forKey: "content_description_edit_icon")
      case .contentDescriptionErrorIcon:
        bundle.localizedString(forKey: "content_description_error_icon")
      case .contentDescriptionEuFlagIcon:
        bundle.localizedString(forKey: "content_description_eu_flag_icon")
      case .contentDescriptionEuMapIcon:
        bundle.localizedString(forKey: "content_description_eu_map_icon")
      case .contentDescriptionFiltersIcon:
        bundle.localizedString(forKey: "content_description_filters_icon")
      case .contentDescriptionHandleBarIcon:
        bundle.localizedString(forKey: "content_description_handle_bar_icon")
      case .contentDescriptionIdIcon:
        bundle.localizedString(forKey: "content_description_id_icon")
      case .contentDescriptionImageOrPlaceholderIcon:
        bundle.localizedString(forKey: "content_description_image_or_placeholder_icon")
      case .contentDescriptionInProgressIcon:
        bundle.localizedString(forKey: "content_description_in_progress_icon")
      case .contentDescriptionInfoIcon:
        bundle.localizedString(forKey: "content_description_info_icon")
      case .contentDescriptionIssuerLogoIcon:
        bundle.localizedString(forKey: "content_description_issuer_logo_icon")
      case .contentDescriptionLogoPlainIcon:
        bundle.localizedString(forKey: "content_description_logo_plain_icon")
      case .contentDescriptionLogoTextIcon:
        bundle.localizedString(forKey: "content_description_logo_text_icon")
      case .contentDescriptionMessageIcon:
        bundle.localizedString(forKey: "content_description_message_icon")
      case .contentDescriptionMoreVertIcon:
        bundle.localizedString(forKey: "content_description_more_vert_icon")
      case .contentDescriptionNationalEidIcon:
        bundle.localizedString(forKey: "content_description_national_eid_icon")
      case .contentDescriptionOpenNewIcon:
        bundle.localizedString(forKey: "content_description_open_new_icon")
      case .contentDescriptionOver18Icon:
        bundle.localizedString(forKey: "content_description_over_18_icon")
      case .contentDescriptionPresentDocumentSameDeviceIcon:
        bundle.localizedString(forKey: "content_description_present_document_same_device_icon")
      case .contentDescriptionQrIcon:
        bundle.localizedString(forKey: "content_description_qr_icon")
      case .contentDescriptionQrScannerIcon:
        bundle.localizedString(forKey: "content_description_qr_scanner_icon")
      case .contentDescriptionScytalesLogoIcon:
        bundle.localizedString(forKey: "content_description_scytales_logo_icon")
      case .contentDescriptionSearchIcon:
        bundle.localizedString(forKey: "content_description_search_icon")
      case .contentDescriptionSettingsIcon:
        bundle.localizedString(forKey: "content_description_settings_icon")
      case .contentDescriptionSuccessIcon:
        bundle.localizedString(forKey: "content_description_success_icon")
      case .contentDescriptionTelekomLogoIcon:
        bundle.localizedString(forKey: "content_description_telekom_logo_icon")
      case .contentDescriptionTouchIdIcon:
        bundle.localizedString(forKey: "content_description_touch_id_icon")
      case .contentDescriptionUserIcon:
        bundle.localizedString(forKey: "content_description_user_icon")
      case .contentDescriptionVerifiedIcon:
        bundle.localizedString(forKey: "content_description_verified_icon")
      case .contentDescriptionWalletActivatedIcon:
        bundle.localizedString(forKey: "content_description_wallet_activated_icon")
      case .contentDescriptionWalletSecuredIcon:
        bundle.localizedString(forKey: "content_description_wallet_secured_icon")
      case .contentDescriptionWarningIcon:
        bundle.localizedString(forKey: "content_description_warning_icon")
      case .documentCategoryEducation:
        bundle.localizedString(forKey: "document_category_education")
      case .documentCategoryFinance:
        bundle.localizedString(forKey: "document_category_finance")
      case .documentCategoryGovernment:
        bundle.localizedString(forKey: "document_category_government")
      case .documentCategoryHealth:
        bundle.localizedString(forKey: "document_category_health")
      case .documentCategoryOther:
        bundle.localizedString(forKey: "document_category_other")
      case .documentCategoryRetail:
        bundle.localizedString(forKey: "document_category_retail")
      case .documentCategorySocialSecurity:
        bundle.localizedString(forKey: "document_category_social_security")
      case .documentCategoryTravel:
        bundle.localizedString(forKey: "document_category_travel")
      case .documentDetailsBooleanItemFalseReadableValue:
        bundle.localizedString(forKey: "document_details_boolean_item_false_readable_value")
      case .documentDetailsBooleanItemTrueReadableValue:
        bundle.localizedString(forKey: "document_details_boolean_item_true_readable_value")
      case .documentProviderSectionHeader:
        bundle.localizedString(forKey: "document_provider_section_header")
      case .documentSuccessCollapsedSupportingText:
        bundle.localizedString(forKey: "document_success_collapsed_supporting_text")
      case .documentSuccessHeaderDescription:
        bundle.localizedString(forKey: "document_success_header_description")
      case .documentSuccessHeaderDescriptionWhenError:
        bundle.localizedString(forKey: "document_success_header_description_when_error")
      case .documentSuccessRelyingPartyDefaultName:
        bundle.localizedString(forKey: "document_success_relying_party_default_name")
      case .documentSuccessStickyButtonText:
        bundle.localizedString(forKey: "document_success_sticky_button_text")
      case .genericAccept:
        bundle.localizedString(forKey: "generic_accept")
      case .genericBack:
        bundle.localizedString(forKey: "generic_back")
      case .genericCancel:
        bundle.localizedString(forKey: "generic_cancel")
      case .genericCancelCapitalized:
        bundle.localizedString(forKey: "generic_cancel_capitalized")
      case .genericClose:
        bundle.localizedString(forKey: "generic_close")
      case .genericContinueCapitalized:
        bundle.localizedString(forKey: "generic_continue_capitalized")
      case .genericDefaultIssuerName:
        bundle.localizedString(forKey: "generic_default_issuer_name")
      case .genericDefaultRelyingPartyName:
        bundle.localizedString(forKey: "generic_default_relying_party_name")
      case .genericDeferredSuccessText:
        bundle.localizedString(forKey: "generic_deferred_success_text")
      case .genericErrorButtonRetry:
        bundle.localizedString(forKey: "generic_error_button_retry")
      case .genericErrorDescription:
        bundle.localizedString(forKey: "generic_error_description")
      case .genericErrorMessage:
        bundle.localizedString(forKey: "generic_error_message")
      case .genericErrorRetry:
        bundle.localizedString(forKey: "generic_error_retry")
      case .genericNetworkErrorMessage:
        bundle.localizedString(forKey: "generic_network_error_message")
      case .genericNo:
        bundle.localizedString(forKey: "generic_no")
      case .genericOk:
        bundle.localizedString(forKey: "generic_ok")
      case .genericOr:
        bundle.localizedString(forKey: "generic_or")
      case .genericScanQr:
        bundle.localizedString(forKey: "generic_scan_qr")
      case .genericSuccess:
        bundle.localizedString(forKey: "generic_success")
      case .genericUnknown:
        bundle.localizedString(forKey: "generic_unknown")
      case .genericViewDetails:
        bundle.localizedString(forKey: "generic_view_details")
      case .genericYes:
        bundle.localizedString(forKey: "generic_yes")
      case .issuanceAddDocumentDeferredSuccessDescription:
        bundle.localizedString(forKey: "issuance_add_document_deferred_success_description")
      case .issuanceAddDocumentDeferredSuccessPrimaryButtonText:
        bundle.localizedString(forKey: "issuance_add_document_deferred_success_primary_button_text")
      case .issuanceAddDocumentDeferredSuccessText:
        bundle.localizedString(forKey: "issuance_add_document_deferred_success_text")
      case .issuanceAddDocumentNoOptions:
        bundle.localizedString(forKey: "issuance_add_document_no_options")
      case .issuanceAddDocumentScanQrFooterButtonText:
        bundle.localizedString(forKey: "issuance_add_document_scan_qr_footer_button_text")
      case .issuanceAddDocumentScanQrFooterText:
        bundle.localizedString(forKey: "issuance_add_document_scan_qr_footer_text")
      case .issuanceAddDocumentSubtitle:
        bundle.localizedString(forKey: "issuance_add_document_subtitle")
      case .issuanceAddDocumentTitle:
        bundle.localizedString(forKey: "issuance_add_document_title")
      case .issuanceCodeCaption(let arg1):
        bundle.localizedStringWithArguments(forKey: "issuance_code_caption", arguments: [arg1])
      case .issuanceCodeTitle(let arg1):
        bundle.localizedStringWithArguments(forKey: "issuance_code_title", arguments: [arg1])
      case .issuanceDocumentOfferDeferredSuccessDescription(let arg1):
        bundle.localizedStringWithArguments(forKey: "issuance_document_offer_deferred_success_description", arguments: [arg1])
      case .issuanceDocumentOfferDeferredSuccessDescriptionWithDoc(let arg1):
        bundle.localizedStringWithArguments(forKey: "issuance_document_offer_deferred_success_description_with_doc", arguments: [arg1])
      case .issuanceDocumentOfferDeferredSuccessDescriptionWithDocAndIssuer(let arg1, let arg2):
        bundle.localizedStringWithArguments(forKey: "issuance_document_offer_deferred_success_description_with_doc_and_issuer", arguments: [arg1, arg2])
      case .issuanceDocumentOfferDeferredSuccessPrimaryButtonText:
        bundle.localizedString(forKey: "issuance_document_offer_deferred_success_primary_button_text")
      case .issuanceDocumentOfferDeferredSuccessText:
        bundle.localizedString(forKey: "issuance_document_offer_deferred_success_text")
      case .issuanceDocumentOfferDescription:
        bundle.localizedString(forKey: "issuance_document_offer_description")
      case .issuanceDocumentOfferErrorInvalidTxcodeFormat(let arg1, let arg2):
        bundle.localizedStringWithArguments(forKey: "issuance_document_offer_error_invalid_txcode_format", arguments: [arg1, arg2])
      case .issuanceDocumentOfferErrorMissingPidText:
        bundle.localizedString(forKey: "issuance_document_offer_error_missing_pid_text")
      case .issuanceDocumentOfferErrorNoDocument:
        bundle.localizedString(forKey: "issuance_document_offer_error_no_document")
      case .issuanceDocumentOfferErrorUnableToFetchTransactionLog:
        bundle.localizedString(forKey: "issuance_document_offer_error_unable_to_fetch_transaction_log")
      case .issuanceDocumentOfferErrorUnableToPresentAndShare:
        bundle.localizedString(forKey: "issuance_document_offer_error_unable_to_present_and_share")
      case .issuanceDocumentOfferHeaderMainText:
        bundle.localizedString(forKey: "issuance_document_offer_header_main_text")
      case .issuanceDocumentOfferPrimaryButtonTextAdd:
        bundle.localizedString(forKey: "issuance_document_offer_primary_button_text_add")
      case .issuanceDocumentOfferRelyingPartyDefaultName:
        bundle.localizedString(forKey: "issuance_document_offer_relying_party_default_name")
      case .issuanceDocumentOfferRelyingPartyDescription:
        bundle.localizedString(forKey: "issuance_document_offer_relying_party_description")
      case .issuanceGenericError:
        bundle.localizedString(forKey: "issuance_generic_error")
      case .issuanceQrScanSubtitle:
        bundle.localizedString(forKey: "issuance_qr_scan_subtitle")
      case .issuanceQrScanTitle:
        bundle.localizedString(forKey: "issuance_qr_scan_title")
      case .issuanceSuccessHeaderDescription:
        bundle.localizedString(forKey: "issuance_success_header_description")
      case .issuanceSuccessHeaderDescriptionWhenError:
        bundle.localizedString(forKey: "issuance_success_header_description_when_error")
      case .issuanceSuccessHeaderIssuerDefaultName:
        bundle.localizedString(forKey: "issuance_success_header_issuer_default_name")
      case .issueDocumentPrompt:
        bundle.localizedString(forKey: "issue_document_prompt")
      case .itemNotFoundInStorage:
        bundle.localizedString(forKey: "item_not_found_in_storage")
      case .itemsNotFoundInStorage:
        bundle.localizedString(forKey: "items_not_found_in_storage")
      case .labelClose:
        bundle.localizedString(forKey: "label_close")
      case .labelTurnOn:
        bundle.localizedString(forKey: "label_turn_on")
      case .landingScreenAddCredentials:
        bundle.localizedString(forKey: "landing_screen_add_credentials")
      case .landingScreenCardAgeVerification:
        bundle.localizedString(forKey: "landing_screen_card_age_verification")
      case .landingScreenCardEuTitle:
        bundle.localizedString(forKey: "landing_screen_card_eu_title")
      case .landingScreenCredentialDetails:
        bundle.localizedString(forKey: "landing_screen_credential_details")
      case .landingScreenCredentialsLeft(let arg1):
        bundle.localizedStringWithArguments(forKey: "landing_screen_credentials_left", arguments: [arg1])
      case .landingScreenNoAgeCredentialFound:
        bundle.localizedString(forKey: "landing_screen_no_age_credential_found")
      case .landingScreenPrimaryButtonLabelScan:
        bundle.localizedString(forKey: "landing_screen_primary_button_label_scan")
      case .landingScreenSubtitle:
        bundle.localizedString(forKey: "landing_screen_subtitle")
      case .landingScreenTitle:
        bundle.localizedString(forKey: "landing_screen_title")
      case .loadingBiometryBiometricsEnabledDescription:
        bundle.localizedString(forKey: "loading_biometry_biometrics_enabled_description")
      case .loadingBiometryBiometricsNotEnabledDescription:
        bundle.localizedString(forKey: "loading_biometry_biometrics_not_enabled_description")
      case .loadingHeaderDescription:
        bundle.localizedString(forKey: "loading_header_description")
      case .mrzCameraError:
        bundle.localizedString(forKey: "mrz_camera_error")
      case .mrzCameraPermissionDenied:
        bundle.localizedString(forKey: "mrz_camera_permission_denied")
      case .mrzCameraSetupFailed:
        bundle.localizedString(forKey: "mrz_camera_setup_failed")
      case .mrzDocumentReady:
        bundle.localizedString(forKey: "mrz_document_ready")
      case .mrzErrorDocumentExpired:
        bundle.localizedString(forKey: "mrz_error_document_expired")
      case .mrzErrorInvalidData:
        bundle.localizedString(forKey: "mrz_error_invalid_data")
      case .mrzErrorProcessingFailed:
        bundle.localizedString(forKey: "mrz_error_processing_failed")
      case .mrzInitializingCamera:
        bundle.localizedString(forKey: "mrz_initializing_camera")
      case .mrzScanning:
        bundle.localizedString(forKey: "mrz_scanning")
      case .mrzUnknownError:
        bundle.localizedString(forKey: "mrz_unknown_error")
      case .nfcBodyInitial:
        bundle.localizedString(forKey: "nfc_body_initial")
      case .nfcBodyReading:
        bundle.localizedString(forKey: "nfc_body_reading")
      case .nfcErrorConnection:
        bundle.localizedString(forKey: "nfc_error_connection")
      case .nfcErrorInvalidMrzKey:
        bundle.localizedString(forKey: "nfc_error_invalid_mrz_key")
      case .nfcErrorMissingData:
        bundle.localizedString(forKey: "nfc_error_missing_data")
      case .nfcErrorMoreThanOneTag:
        bundle.localizedString(forKey: "nfc_error_more_than_one_tag")
      case .nfcErrorReadingFailed:
        bundle.localizedString(forKey: "nfc_error_reading_failed")
      case .nfcErrorReadingTag:
        bundle.localizedString(forKey: "nfc_error_reading_tag")
      case .nfcErrorTagNotValid:
        bundle.localizedString(forKey: "nfc_error_tag_not_valid")
      case .nfcErrorUnexpected:
        bundle.localizedString(forKey: "nfc_error_unexpected")
      case .nfcErrorUserCanceled:
        bundle.localizedString(forKey: "nfc_error_user_canceled")
      case .nfcHelpLink:
        bundle.localizedString(forKey: "nfc_help_link")
      case .nfcTitle:
        bundle.localizedString(forKey: "nfc_title")
      case .nfcTitleInitial:
        bundle.localizedString(forKey: "nfc_title_initial")
      case .nfcTitleReading:
        bundle.localizedString(forKey: "nfc_title_reading")
      case .onboardingStep1Title:
        bundle.localizedString(forKey: "onboarding_step_1_title")
      case .onboardingStep2Title:
        bundle.localizedString(forKey: "onboarding_step_2_title")
      case .onboardingStep3Title:
        bundle.localizedString(forKey: "onboarding_step_3_title")
      case .onboardingStep4Title:
        bundle.localizedString(forKey: "onboarding_step_4_title")
      case .onboardingTokenQrIntroTitle:
        bundle.localizedString(forKey: "onboarding_token_qr_intro_title")
      case .onboardingTokenQrIntroDescription:
        bundle.localizedString(forKey: "onboarding_token_qr_intro_description")
      case .onboardingVerificationTokenQr:
        bundle.localizedString(forKey: "onboarding_verification_token_qr")
      case .onboardingVerificationTokenQrDescription:
        bundle.localizedString(forKey: "onboarding_verification_token_qr_description")
      case .onboardingVerificationDescription:
        bundle.localizedString(forKey: "onboarding_verification_description")
      case .onboardingVerificationNationalId:
        bundle.localizedString(forKey: "onboarding_verification_national_id")
      case .onboardingVerificationNationalIdDescription:
        bundle.localizedString(forKey: "onboarding_verification_national_id_description")
      case .onboardingVerificationNationalIdHint:
        bundle.localizedString(forKey: "onboarding_verification_national_id_hint")
      case .onboardingVerificationPassportIdCard:
        bundle.localizedString(forKey: "onboarding_verification_passport_id_card")
      case .onboardingVerificationPassportIdCardDescription:
        bundle.localizedString(forKey: "onboarding_verification_passport_id_card_description")
      case .onboardingVerificationTitle:
        bundle.localizedString(forKey: "onboarding_verification_title")
      case .openSystemSettings:
        bundle.localizedString(forKey: "open_system_settings")
      case .passportBiometrics:
        bundle.localizedString(forKey: "passport_biometrics")
      case .passportBiometricsBack:
        bundle.localizedString(forKey: "passport_biometrics_back")
      case .passportBiometricsContentDescription:
        bundle.localizedString(forKey: "passport_biometrics_content_description")
      case .passportBiometricsDob:
        bundle.localizedString(forKey: "passport_biometrics_dob")
      case .passportBiometricsDoe:
        bundle.localizedString(forKey: "passport_biometrics_doe")
      case .passportBiometricsFirstDescription:
        bundle.localizedString(forKey: "passport_biometrics_first_description")
      case .passportBiometricsFirstHeader:
        bundle.localizedString(forKey: "passport_biometrics_first_header")
      case .passportBiometricsFirstLink:
        bundle.localizedString(forKey: "passport_biometrics_first_link")
      case .passportBiometricsNext:
        bundle.localizedString(forKey: "passport_biometrics_next")
      case .passportBiometricsNoAvailability:
        bundle.localizedString(forKey: "passport_biometrics_no_availability")
      case .passportBiometricsNoPassportData:
        bundle.localizedString(forKey: "passport_biometrics_no_passport_data")
      case .passportBiometricsPassport:
        bundle.localizedString(forKey: "passport_biometrics_passport")
      case .passportBiometricsScanCancelled:
        bundle.localizedString(forKey: "passport_biometrics_scan_cancelled")
      case .passportBiometricsTryAgain:
        bundle.localizedString(forKey: "passport_biometrics_try_again")
      case .passportBiometricsUnknownError:
        bundle.localizedString(forKey: "passport_biometrics_unknown_error")
      case .passportBiometricsVerifyData:
        bundle.localizedString(forKey: "passport_biometrics_verify_data")
      case .passportCaptureSubtitle:
        bundle.localizedString(forKey: "passport_capture_subtitle")
      case .passportCaptureTitle:
        bundle.localizedString(forKey: "passport_capture_title")
      case .passportCredentialIssuanceDescription:
        bundle.localizedString(forKey: "passport_credential_issuance_description")
      case .passportCredentialIssuanceTitle:
        bundle.localizedString(forKey: "passport_credential_issuance_title")
      case .passportIdentification:
        bundle.localizedString(forKey: "passport_identification")
      case .passportIdentificationBack:
        bundle.localizedString(forKey: "passport_identification_back")
      case .passportIdentificationCapture:
        bundle.localizedString(forKey: "passport_identification_capture")
      case .passportIdentificationDescription:
        bundle.localizedString(forKey: "passport_identification_description")
      case .passportIdentificationFooter:
        bundle.localizedString(forKey: "passport_identification_footer")
      case .passportIdentificationStepFirst:
        bundle.localizedString(forKey: "passport_identification_step_first")
      case .passportIdentificationStepSecond:
        bundle.localizedString(forKey: "passport_identification_step_second")
      case .passportIdentificationTitle:
        bundle.localizedString(forKey: "passport_identification_title")
      case .passportLiveVideo:
        bundle.localizedString(forKey: "passport_live_video")
      case .passportLiveVideoBack:
        bundle.localizedString(forKey: "passport_live_video_back")
      case .passportLiveVideoDescription:
        bundle.localizedString(forKey: "passport_live_video_description")
      case .passportLiveVideoDownloadingProgress(let arg1, let arg2):
        bundle.localizedStringWithArguments(forKey: "passport_live_video_downloading_progress", arguments: [arg1, arg2])
      case .passportLiveVideoErrorNotLive:
        bundle.localizedString(forKey: "passport_live_video_error_not_live")
      case .passportLiveVideoErrorNotMatching:
        bundle.localizedString(forKey: "passport_live_video_error_not_matching")
      case .passportLiveVideoErrorNotProcessed:
        bundle.localizedString(forKey: "passport_live_video_error_not_processed")
      case .passportLiveVideoFooter:
        bundle.localizedString(forKey: "passport_live_video_footer")
      case .passportLiveVideoHeader:
        bundle.localizedString(forKey: "passport_live_video_header")
      case .passportLiveVideoLiveCapture:
        bundle.localizedString(forKey: "passport_live_video_live_capture")
      case .passportLiveVideoStepFirst:
        bundle.localizedString(forKey: "passport_live_video_step_first")
      case .passportLiveVideoStepSecond:
        bundle.localizedString(forKey: "passport_live_video_step_second")
      case .passportLiveVideoStepThird:
        bundle.localizedString(forKey: "passport_live_video_step_third")
      case .passportScanIntroBackButton:
        bundle.localizedString(forKey: "passport_scan_intro_back_button")
      case .passportScanIntroDataDownloadNotice:
        bundle.localizedString(forKey: "passport_scan_intro_data_download_notice")
      case .passportScanIntroDescription:
        bundle.localizedString(forKey: "passport_scan_intro_description")
      case .passportScanIntroEnrollmentMethod:
        bundle.localizedString(forKey: "passport_scan_intro_enrollment_method")
      case .passportScanIntroStartButton:
        bundle.localizedString(forKey: "passport_scan_intro_start_button")
      case .passportScanIntroStep1Description:
        bundle.localizedString(forKey: "passport_scan_intro_step_1_description")
      case .passportScanIntroStep1Title:
        bundle.localizedString(forKey: "passport_scan_intro_step_1_title")
      case .passportScanIntroStep2Description:
        bundle.localizedString(forKey: "passport_scan_intro_step_2_description")
      case .passportScanIntroStep2Title:
        bundle.localizedString(forKey: "passport_scan_intro_step_2_title")
      case .passportScanIntroStep3Description:
        bundle.localizedString(forKey: "passport_scan_intro_step_3_description")
      case .passportScanIntroStep3Title:
        bundle.localizedString(forKey: "passport_scan_intro_step_3_title")
      case .passportScanIntroStep4Title:
        bundle.localizedString(forKey: "passport_scan_intro_step_4_title")
      case .passportScanIntroStep5Title:
        bundle.localizedString(forKey: "passport_scan_intro_step_5_title")
      case .passportScanIntroTitle:
        bundle.localizedString(forKey: "passport_scan_intro_title")
      case .passportValidationErrorExpired:
        bundle.localizedString(forKey: "passport_validation_error_expired")
      case .passportValidationErrorIncompleteData:
        bundle.localizedString(forKey: "passport_validation_error_incomplete_data")
      case .passportValidationErrorUnderage:
        bundle.localizedString(forKey: "passport_validation_error_underage")
      case .presentationQrScanSubtitle:
        bundle.localizedString(forKey: "presentation_qr_scan_subtitle")
      case .presentationQrScanTitle:
        bundle.localizedString(forKey: "presentation_qr_scan_title")
      case .proximityConnectionBleDescription:
        bundle.localizedString(forKey: "proximity_connection_ble_description")
      case .proximityConnectivityCaption:
        bundle.localizedString(forKey: "proximity_connectivity_caption")
      case .qrScanInformativeTextIssuanceFlow:
        bundle.localizedString(forKey: "qr_scan_informative_text_issuance_flow")
      case .qrScanInformativeTextPresentationFlow:
        bundle.localizedString(forKey: "qr_scan_informative_text_presentation_flow")
      case .qrScanPermissionNotGranted:
        bundle.localizedString(forKey: "qr_scan_permission_not_granted")
      case .quickPinBottomSheetCancelPrimaryButtonText:
        bundle.localizedString(forKey: "quick_pin_bottom_sheet_cancel_primary_button_text")
      case .quickPinBottomSheetCancelSecondaryButtonText:
        bundle.localizedString(forKey: "quick_pin_bottom_sheet_cancel_secondary_button_text")
      case .quickPinBottomSheetCancelSubtitle:
        bundle.localizedString(forKey: "quick_pin_bottom_sheet_cancel_subtitle")
      case .quickPinBottomSheetCancelTitle:
        bundle.localizedString(forKey: "quick_pin_bottom_sheet_cancel_title")
      case .quickPinCantUsePreviousPin:
        bundle.localizedString(forKey: "quick_pin_cant_use_previous_pin")
      case .quickPinChangeEnterNewSubtitle:
        bundle.localizedString(forKey: "quick_pin_change_enter_new_subtitle")
      case .quickPinChangeHelpText:
        bundle.localizedString(forKey: "quick_pin_change_help_text")
      case .quickPinChangeLockoutCountdownMinutes(let arg1, let arg2):
        bundle.localizedStringWithArguments(forKey: "quick_pin_change_lockout_countdown_minutes", arguments: [arg1, arg2])
      case .quickPinChangeLockoutCountdownSeconds(let arg1):
        bundle.localizedStringWithArguments(forKey: "quick_pin_change_lockout_countdown_seconds", arguments: [arg1])
      case .quickPinChangeReenterNewSubtitle:
        bundle.localizedString(forKey: "quick_pin_change_reenter_new_subtitle")
      case .quickPinChangeSuccessBtn:
        bundle.localizedString(forKey: "quick_pin_change_success_btn")
      case .quickPinChangeSuccessDescription:
        bundle.localizedString(forKey: "quick_pin_change_success_description")
      case .quickPinChangeSuccessText:
        bundle.localizedString(forKey: "quick_pin_change_success_text")
      case .quickPinChangeTitle:
        bundle.localizedString(forKey: "quick_pin_change_title")
      case .quickPinChangeValidateCurrentSubtitle:
        bundle.localizedString(forKey: "quick_pin_change_validate_current_subtitle")
      case .quickPinConfirmButton:
        bundle.localizedString(forKey: "quick_pin_confirm_button")
      case .quickPinCreateEnterSubtitle:
        bundle.localizedString(forKey: "quick_pin_create_enter_subtitle")
      case .quickPinCreateReenterSubtitle:
        bundle.localizedString(forKey: "quick_pin_create_reenter_subtitle")
      case .quickPinCreateReenterTitle:
        bundle.localizedString(forKey: "quick_pin_create_reenter_title")
      case .quickPinCreateTitle:
        bundle.localizedString(forKey: "quick_pin_create_title")
      case .quickPinInvalidError:
        bundle.localizedString(forKey: "quick_pin_invalid_error")
      case .quickPinInvalidGenericError:
        bundle.localizedString(forKey: "quick_pin_invalid_generic_error")
      case .quickPinInvalidLastAttempt:
        bundle.localizedString(forKey: "quick_pin_invalid_last_attempt")
      case .quickPinInvalidWithAttempts(let arg1):
        bundle.localizedStringWithArguments(forKey: "quick_pin_invalid_with_attempts", arguments: [arg1])
      case .quickPinLockedOut:
        bundle.localizedString(forKey: "quick_pin_locked_out")
      case .quickPinLockoutCountdownMinutes(let arg1, let arg2):
        bundle.localizedStringWithArguments(forKey: "quick_pin_lockout_countdown_minutes", arguments: [arg1, arg2])
      case .quickPinLockoutCountdownSeconds(let arg1):
        bundle.localizedStringWithArguments(forKey: "quick_pin_lockout_countdown_seconds", arguments: [arg1])
      case .quickPinNextButton:
        bundle.localizedString(forKey: "quick_pin_next_button")
      case .quickPinNonMatch:
        bundle.localizedString(forKey: "quick_pin_non_match")
      case .quickPinNumericalRuleInvalidErrorMessage:
        bundle.localizedString(forKey: "quick_pin_numerical_rule_invalid_error_message")
      case .requestBottomSheetWarningSubtitle:
        bundle.localizedString(forKey: "request_bottom_sheet_warning_subtitle")
      case .requestBottomSheetWarningTitle:
        bundle.localizedString(forKey: "request_bottom_sheet_warning_title")
      case .requestCollapsedSupportingText:
        bundle.localizedString(forKey: "request_collapsed_supporting_text")
      case .requestDataInfoNotice:
        bundle.localizedString(forKey: "request_data_info_notice")
      case .requestDataVerifiedEntityMessage:
        bundle.localizedString(forKey: "request_data_verified_entity_message")
      case .requestGenderFemale:
        bundle.localizedString(forKey: "request_gender_female")
      case .requestGenderMale:
        bundle.localizedString(forKey: "request_gender_male")
      case .requestGenderNotApplicable:
        bundle.localizedString(forKey: "request_gender_not_applicable")
      case .requestGenderNotKnown:
        bundle.localizedString(forKey: "request_gender_not_known")
      case .requestHeaderDescription:
        bundle.localizedString(forKey: "request_header_description")
      case .requestHeaderMainText:
        bundle.localizedString(forKey: "request_header_main_text")
      case .requestNoData:
        bundle.localizedString(forKey: "request_no_data")
      case .requestRelyingPartyDefaultName:
        bundle.localizedString(forKey: "request_relying_party_default_name")
      case .requestRelyingPartyDescription:
        bundle.localizedString(forKey: "request_relying_party_description")
      case .requestStickyButtonText:
        bundle.localizedString(forKey: "request_sticky_button_text")
      case .requestWarningText:
        bundle.localizedString(forKey: "request_warning_text")
      case .requiredNfcNotSupported:
        bundle.localizedString(forKey: "required_nfc_not_supported")
      case .requiredPermsNotGiven:
        bundle.localizedString(forKey: "required_perms_not_given")
      case .settings:
        bundle.localizedString(forKey: "settings")
      case .settingsScreenAppInfo:
        bundle.localizedString(forKey: "settings_screen_app_info")
      case .settingsScreenChangePin:
        bundle.localizedString(forKey: "settings_screen_change_pin")
      case .settingsScreenCredentials:
        bundle.localizedString(forKey: "settings_screen_credentials")
      case .settingsScreenDeleteProofs:
        bundle.localizedString(forKey: "settings_screen_delete_proofs")
      case .settingsScreenSecurity:
        bundle.localizedString(forKey: "settings_screen_security")
      case .settingsScreenTitle:
        bundle.localizedString(forKey: "settings_screen_title")
      case .settingsScreenVersion:
        bundle.localizedString(forKey: "settings_screen_version")
      case .splashScreenSponsors:
        bundle.localizedString(forKey: "splash_screen_sponsors")
      case .splashScreenTitle:
        bundle.localizedString(forKey: "splash_screen_title")
      case .unknownVerifier:
        bundle.localizedString(forKey: "unknown_verifier")
      case .unsupportedDeviceMessage:
        bundle.localizedString(forKey: "unsupported_device_message")
      case .unsupportedDeviceTitle:
        bundle.localizedString(forKey: "unsupported_device_title")
      case .warningAuthenticationFailed:
        bundle.localizedString(forKey: "warning_authentication_failed")
      case .warningClaNotSupported:
        bundle.localizedString(forKey: "warning_cla_not_supported")
      case .warningEnableNfc:
        bundle.localizedString(forKey: "warning_enable_nfc")
      case .welcomePage1:
        bundle.localizedString(forKey: "welcome_page_1")
      case .welcomePage2:
        bundle.localizedString(forKey: "welcome_page_2")
      case .welcomePage3:
        bundle.localizedString(forKey: "welcome_page_3")
      case .welcomeScreenNext:
        bundle.localizedString(forKey: "welcome_screen_next")
      case .welcomeScreenSkip:
        bundle.localizedString(forKey: "welcome_screen_skip")
      case .welcomeTitle1:
        bundle.localizedString(forKey: "welcome_title_1")
      case .welcomeTitle2:
        bundle.localizedString(forKey: "welcome_title_2")
      case .welcomeTitle3:
        bundle.localizedString(forKey: "welcome_title_3")
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
