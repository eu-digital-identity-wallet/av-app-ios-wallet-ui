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
    case .requestDataCaption:
      bundle.localizedString(forKey: "request_data_share_caption")
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
    case .welcomeBack(let args):
      bundle.localizedStringWithArguments(forKey: "welcome_back", arguments: args)
    case .viewDocumentDetails:
      bundle.localizedString(forKey: "view_document_details")
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
    case .proximityConnectivityCaption:
      bundle.localizedString(forKey: "proxmity_connectivity_caption")
    case .unavailableField:
      bundle.localizedString(forKey: "unavailable_field")
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
    case .successTitlePunctuated:
      bundle.localizedString(forKey: "issuance_success_title_punctuated")
    case .unknownVerifier:
      bundle.localizedString(forKey: "unknown_verifier")
    case .unknownIssuer:
      bundle.localizedString(forKey: "unknown_issuer")
    case .genericIssuer:
      bundle.localizedString(forKey: "generic_issuer")
    case .yes:
      bundle.localizedString(forKey: "yes")
    case .no:
      bundle.localizedString(forKey: "no")
    case .scanQrCode:
      bundle.localizedString(forKey: "scan_qr_code")
    case .validUntil(let args):
      bundle.localizedStringWithArguments(forKey: "valid_until", arguments: args)
    case .bleDisabledModalTitle:
      bundle.localizedString(forKey: "ble_disabled_modal_title")
    case .bleDisabledModalCaption:
      bundle.localizedString(forKey: "ble_disabled_modal_content")
    case .bleDisabledModalButton:
      bundle.localizedString(forKey: "ble_disabled_modal_button")
    case .requestDataNoDocument:
      bundle.localizedString(forKey: "request_data_no_document")
    case .issuanceDetailsDeletionTitle(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_details_doc_deletion_title", arguments: args)
    case .deleteDocument:
      bundle.localizedString(forKey: "delete_document")
    case .issuanceDetailsDeletionCaption(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_details_doc_deletion_caption", arguments: args)
    case .errorUnableFetchDocuments:
      bundle.localizedString(forKey: "error_unable_fetch_documents")
    case .errorUnableFetchDocument:
      bundle.localizedString(forKey: "error_unable_fetch_document")
    case .scannerQrTitle:
      bundle.localizedString(forKey: "scanner_qr_title")
    case .scannerQrCaption:
      bundle.localizedString(forKey: "scanner_qr_caption")
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
    case .missingMetadata:
      bundle.localizedString(forKey: "missing_metadata")
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
    case .issuanceFailed:
      bundle.localizedString(forKey: "issuance_failed")
    case .pending:
      bundle.localizedString(forKey: "pending")
    case .deferredDocumentsIssuedModalTitle:
      bundle.localizedString(forKey: "deferred_document_issued_modal_title")
    case .defferedDocumentsIssuedModalCaption:
      bundle.localizedString(forKey: "deferred_document_issued_modal_caption")
    case .retrieveLogs:
      bundle.localizedString(forKey: "retrieve_logs")
    case .qrScanInformativeText:
      bundle.localizedString(forKey: "qr_scan_informative_text")
    case .unableToPresentAndShare:
      bundle.localizedString(forKey: "error_unable_present_documents")
    case .signDocument:
      bundle.localizedString(forKey: "sign_document")
    case .signDocumentSubtitle:
      bundle.localizedString(forKey: "sign_document_subtitle")
    case .selectDocument:
      bundle.localizedString(forKey: "select_document")
    case .itemNotFoundInStorage:
      bundle.localizedString(forKey: "item_not_found_in_storage")
    case .itemsNotFoundInStorage:
      bundle.localizedString(forKey: "items_not_found_in_storage")
    case .home:
      bundle.localizedString(forKey: "home")
    case .transactions:
      bundle.localizedString(forKey: "transactions")
    case .documents:
      bundle.localizedString(forKey: "documents")
    case .authenticateAuthoriseTransactions:
      bundle.localizedString(forKey: "authenticate_authorise_transactions")
    case .electronicallySignDigitalDocuments:
      bundle.localizedString(forKey: "electronically_sign_digital_documents")
    case .learnMore:
      bundle.localizedString(forKey: "learn_more")
    case .chooseFromList:
      bundle.localizedString(forKey: "choose_from_list")
    case .chooseFromListTitle:
      bundle.localizedString(forKey: "choose_from_list_title")
    case .addDocumentsToWallet:
      bundle.localizedString(forKey: "add_documents_to_wallet")
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
    case .filterByIssuer:
      bundle.localizedString(forKey: "filter_by_issuer")
    case .alertAccessOnlineServices:
      bundle.localizedString(forKey: "alert_access_online_services")
    case .alertAccessOnlineServicesMessage:
      bundle.localizedString(forKey: "alert_access_online_services_message")
    case .alertSignDocumentsSafely:
      bundle.localizedString(forKey: "alert_sign_documents_safely")
    case .alertSignDocumentsSafelyMessage:
      bundle.localizedString(forKey: "alert_sign_documents_safely_message")
    case .authenticate:
      bundle.localizedString(forKey: "authenticate")
    case .inPerson:
      bundle.localizedString(forKey: "in_person")
    case .online:
      bundle.localizedString(forKey: "Online")
    case .savedToFavorites:
      bundle.localizedString(forKey: "saved_to_favorites")
    case .succesfullyAddedFollowingToWallet:
      bundle.localizedString(forKey: "succesfully_added_following_to_wallet")
    case .removedFromFavorites:
      bundle.localizedString(forKey: "removed_from_favorites")
    case .savedToFavoritesMessage:
      bundle.localizedString(forKey: "saved_to_favorites_message")
    case .removedFromFavoritesMessages:
      bundle.localizedString(forKey: "removed_from_favorites_messages")
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
    case .walletIsSecured:
      bundle.localizedString(forKey: "wallet_is_secured")
    case .noResults:
      bundle.localizedString(forKey: "no_results")
    case .noResultsDocumentsDescription:
      bundle.localizedString(forKey: "no_results_documents_description")
    case .noResultsTransactionsDescription:
      bundle.localizedString(forKey: "no_results_transactions_description")
    case .proximityConnectionBleDescription:
      bundle.localizedString(forKey: "proximity_connection_ble_description")
    case .filters:
      bundle.localizedString(forKey: "filters")
    case .sortByIssuedDateSectionTitle:
      bundle.localizedString(forKey: "sort_by_issued_date")
    case .showResults:
      bundle.localizedString(forKey: "show_results")
    case .reset:
      bundle.localizedString(forKey: "reset")
    case .all:
      bundle.localizedString(forKey: "all")
    case .descending:
      bundle.localizedString(forKey: "descending")
    case .ascending:
      bundle.localizedString(forKey: "ascending")
    case .selectExpiryPeriod:
      bundle.localizedString(forKey: "expiry_period")
    case .filterByState:
      bundle.localizedString(forKey: "filter_by_state")
    case .sortBy:
      bundle.localizedString(forKey: "sort_by")
    case .deleteDocumentConfirmDialog:
      bundle.localizedString(forKey: "delete_document_confirm_dialog")
    case .defaultLabel:
      bundle.localizedString(forKey: "default")
    case .valid:
      bundle.localizedString(forKey: "valid")
    case .revoke:
      bundle.localizedString(forKey: "revoke")
    case .expired:
      bundle.localizedString(forKey: "expired")
    case .dateIssued:
      bundle.localizedString(forKey: "date_issued")
    case .expiryDate:
      bundle.localizedString(forKey: "expiry_date")
    case .nextSevenDays:
      bundle.localizedString(forKey: "next_seven_days")
    case .nextThirtyDays:
      bundle.localizedString(forKey: "next_thirty_days")
    case .beyondThiryDays:
      bundle.localizedString(forKey: "beyond_thirty_days")
    case .beforeToday:
      bundle.localizedString(forKey: "before_today")
    case .issuanceRequest:
      bundle.localizedString(forKey: "issuance_request")
    case .myEuWallet:
      bundle.localizedString(forKey: "My EU Wallet")
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
    case .orderBy:
      bundle.localizedString(forKey: "order_by")
    case .filterByCategory:
      bundle.localizedString(forKey: "filter_by_category")
    case .searchDocuments:
      bundle.localizedString(forKey: "search_documents")
    case .searchTransactions:
      bundle.localizedString(forKey: "search_transactions")
    case .filterByStatus:
      bundle.localizedString(forKey: "filter_by_status")
    case .completed:
      bundle.localizedString(forKey: "completed")
    case .failed:
      bundle.localizedString(forKey: "failed")
    case .filterByDate:
      bundle.localizedString(forKey: "filter_by_date")
    case .startDate:
      bundle.localizedString(forKey: "start_date")
    case .endDate:
      bundle.localizedString(forKey: "end_date")
    case .relyingParty:
      bundle.localizedString(forKey: "relying_party")
    case .signedDocuments:
      bundle.localizedString(forKey: "signed_documents")
    case .transactionInformation:
      bundle.localizedString(forKey: "transaction_information")
    case .transactionDetailsDataSigned:
      bundle.localizedString(forKey: "transaction_details_data_signed")
    case .transactionDetailsDataShare:
      bundle.localizedString(forKey: "transaction_details_data_shared")
    case .transactionDetailsScreenCardDateLabel:
      bundle.localizedString(forKey: "transaction_details_screen_card_date_label")
    case .transactionDetailsCompleted:
      bundle.localizedString(forKey: "transaction_details_completed")
    case .or:
      bundle.localizedString(forKey: "or")
    case .today:
      bundle.localizedString(forKey: "today")
    case .thisWeek:
      bundle.localizedString(forKey: "this_week")
    case .unknownDate:
      bundle.localizedString(forKey: "unknown_date")
    case .minutesAgo(let args):
      bundle.localizedStringWithArguments(forKey: "minutes_ago", arguments: args)
    case .minuteAgo(let args):
      bundle.localizedStringWithArguments(forKey: "minute_ago", arguments: args)
    case .transactionDate:
      bundle.localizedString(forKey: "transaction_date")
    case .filterByType:
      bundle.localizedString(forKey: "filter_by_type")
    case .presentation:
      bundle.localizedString(forKey: "presentation")
    case .signing:
      bundle.localizedString(forKey: "signing")
    case .issuance:
      bundle.localizedString(forKey: "issuance")
    case .withoutRelyingName:
      bundle.localizedString(forKey: "without_relying_name")
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
    case .consentCheckboxLabel3:
        bundle.localizedString(forKey: "consent_checkbox_label_3")
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
    case .quickPinTitle:
        bundle.localizedString(forKey: "quick_pin_title")
    case .verificationStepTitle:
        bundle.localizedString(forKey: "onboarding_verification_title")
    case .verificationStepDescription:
        bundle.localizedString(forKey: "onboarding_verification_description")
    case .verificationNationalId:
        bundle.localizedString(forKey: "onboarding_verification_national_id")
    case .verificationNationalIdDescription:
        bundle.localizedString(forKey: "onboarding_verification_national_id_description")
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
    case .changeQuickPinCaption:
        bundle.localizedString(forKey: "change_quick_pin_caption")
    case .changePinDescription:
        bundle.localizedString(forKey: "change_pin_description")
    case .changePinFirstPinDescription:
        bundle.localizedString(forKey: "change_pin_first_pin_description")
    case .changePinSecondPinDescription:
        bundle.localizedString(forKey: "change_pin_second_pin_description")
    case .changePinHelpText:
        bundle.localizedString(forKey: "change_pin_help_text")
    case .changePinSuccessText:
        bundle.localizedString(forKey: "change_pin_success_text")
    case .credentialIssuanceTitle:
      bundle.localizedString(forKey: "credential_issuance_title")
    case .credentialIssuanceDescription:
      bundle.localizedString(forKey: "credential_issuance_description")
    case .incomplete:
      bundle.localizedString(forKey: "incomplete")
    case .justNow:
      bundle.localizedString(forKey: "just_now")
    case .revoked:
      bundle.localizedString(forKey: "revoked")
    case .documentDetailsRevokedDocumentMessage:
      bundle.localizedString(forKey: "document_details_revoked_document_message")
    case .revokedModalTitle:
      bundle.localizedString(forKey: "revoked_modal_title")
    case .revokedModalDescription:
      bundle.localizedString(forKey: "revoked_modal_description")
    case .transactionDetailsRequestDeletionMessage:
      bundle.localizedString(forKey: "transaction_details_eequest_deletion_message")
    case .transactionDetailsRequestDeletionButton:
      bundle.localizedString(forKey: "transaction_details_eequest_deletion_button")
    case .transactionDetailsReportTransactionMessage:
      bundle.localizedString(forKey: "transaction_details_report_transaction_message")
    case .transactionDetailsReportTransactionButton:
      bundle.localizedString(forKey: "transaction_detailsReport_transaction_button")
    case .documentDetailsDocumentCredentialsText(let args):
      bundle.localizedStringWithArguments(forKey: "document_details_document_credentials_text", arguments: args)
    case .documentDetailsDocumentCredentialsMoreInfoText:
      bundle.localizedString(forKey: "document_details_document_credentials_more_info_text")
    case .documentDetailsDocumentCredentialsExpandedTextSubtitle:
      bundle.localizedString(forKey: "document_details_document_credentials_expanded_text_subtitle")
    case .documentDetailsDocumentCredentialsExpandedButtonHideText:
      bundle.localizedString(forKey: "document_details_document_credentials_expanded_button_hide_text")
    case .documentsListCredentialsUsageText(let args):
      bundle.localizedStringWithArguments(forKey: "documents_list_credentials_usage_text", arguments: args)
    case .expandableDocumentCredentialsIssueButton:
      bundle.localizedString(forKey: "expandable_document_credentials_issue_button")
    case .issuanceAddDocumentNoOptions:
      bundle.localizedString(forKey: "issuance_add_document_no_options")
    case .settingsSupport:
      bundle.localizedString(forKey: "settings_support")
    case .settingsUnlockWithBiometrics:
      bundle.localizedString(forKey: "settings_unlock_with_biometrics")
    case .settingsDeleteAllProofsOfAttestation:
      bundle.localizedString(forKey: "settings_delete_all_proofs_attestation")
    case .settingsTermsOfService:
      bundle.localizedString(forKey: "settings_terms_of_service")
    case .settingsLanguage:
      bundle.localizedString(forKey: "settings_language")
    case .settingsAboutThisApp:
      bundle.localizedString(forKey: "settings_about_this_app")
    case .acceptButton:
      bundle.localizedString(forKey: "accept_button")
    case .proofOfAgeTitle:
      bundle.localizedString(forKey: "proof_of_age_title")
    case .documentProviderSectionHeader:
      bundle.localizedString(forKey: "document_provider_section_header")
    case .unknown:
      bundle.localizedString(forKey: "unknown")

    case .passportIdentificationTitle:
        bundle.localizedString(forKey: "passport_identification_title")
    case .passportIdentificationDescription:
        bundle.localizedString(forKey: "passport_identification_description")
    case .passportIdentificationStepFirst:
        bundle.localizedString(forKey: "passport_identification_step_first")
    case .passportIdentificationStepSecond:
        bundle.localizedString(forKey: "passport_identification_step_second")
    case .passportIdentificationFooter:
        bundle.localizedString(forKey: "passport_identification_footer")
    case .passportIdentificationBack:
        bundle.localizedString(forKey: "passport_identification_back")
    case .passportIdentificationCapture:
        bundle.localizedString(forKey: "passport_identification_capture")
    case .passportCaptureTitle:
        bundle.localizedString(forKey: "passport_capture_title")
    case .passportCaptureSubtitle:
        bundle.localizedString(forKey: "passport_capture_subtitle")
    case .passportIdentification:
        bundle.localizedString(forKey: "passport_identification")
    case .passportBiometrics:
        bundle.localizedString(forKey: "passport_biometrics")
    case .passportLiveVideo:
        bundle.localizedString(forKey: "passport_live_video")
    case .passportBiometricsBack:
        bundle.localizedString(forKey: "passport_biometrics_back")
    case .passportBiometricsNext:
        bundle.localizedString(forKey: "passport_biometrics_next")
    case .passportBiometricsContentDescription:
        bundle.localizedString(forKey: "passport_biometrics_content_description")
    case .passportBiometricsFirstHeader:
        bundle.localizedString(forKey: "passport_biometrics_first_header")
      case .passportBiometricsFirstDescription:
        bundle.localizedString(forKey: "passport_biometrics_first_description")
      case .passportBiometricsFirstLink:
        bundle.localizedString(forKey: "passport_biometrics_first_link")
      case .passportBiometricsVerifyData:
        bundle.localizedString(forKey: "passport_biometrics_verify_data")
      case .passportBiometricsTryAgain:
        bundle.localizedString(forKey: "passport_biometrics_try_again")
      case .passportBiometricsPassport:
        bundle.localizedString(forKey: "passport_biometrics_passport")
      case .passportBiometricsDob:
        bundle.localizedString(forKey: "passport_biometrics_dob")
      case .passportBiometricsDoe:
        bundle.localizedString(forKey: "passport_biometrics_doe")
      case .passportBiometricsNoAvailability:
        bundle.localizedString(forKey: "passport_biometrics_no_availability")
      case .passportBiometricsNoPassportData:
        bundle.localizedString(forKey: "passport_biometrics_no_passport_data")
      case .passportBiometricsScanCancelled:
        bundle.localizedString(forKey: "passport_biometrics_scan_cancelled")
      case .passportBiometricsUnknownError:
        bundle.localizedString(forKey: "passport_biometrics_unknown_error")
      case .passportLiveVideoHeader:
        bundle.localizedString(forKey: "passport_live_video_header")
      case .passportLiveVideoDescription:
        bundle.localizedString(forKey: "passport_live_video_description")
      case .passportLiveVideoStepFirst:
        bundle.localizedString(forKey: "passport_live_video_step_first")
      case .passportLiveVideoStepSecond:
        bundle.localizedString(forKey: "passport_live_video_step_second")
      case .passportLiveVideoStepThird:
        bundle.localizedString(forKey: "passport_live_video_step_third")
      case .passportLiveVideoFooter:
        bundle.localizedString(forKey: "passport_live_video_footer")
      case .passportLiveVideoBack:
        bundle.localizedString(forKey: "passport_live_video_back")
      case .passportLiveVideoLiveCapture:
        bundle.localizedString(forKey: "passport_live_video_live_capture")
      case .passportLiveVideoErrorNotProcessed:
        bundle.localizedString(forKey: "passport_live_video_error_not_processed")
      case .passportLiveVideoErrorNotLive:
        bundle.localizedString(forKey: "passport_live_video_error_not_live")
      case .passportLiveVideoErrorNotMatching:
        bundle.localizedString(forKey: "passport_live_video_error_not_matching")
      case .passportValidationErrorExpired:
        bundle.localizedString(forKey: "passport_validation_error_expired")
      case .passportValidationErrorUnderage:
        bundle.localizedString(forKey: "passport_validation_error_underage")
      case .passportValidationErrorIncompleteData:
        bundle.localizedString(forKey: "passport_validation_error_incomplete_data")
      case .passportLiveVideoDownloadingProgress:
        bundle.localizedString(forKey: "passport_live_video_downloading_progress")
      case .passportCredentialIssuanceTitle:
        bundle.localizedString(forKey: "passport_credential_issuance_title")
      case .passportCredentialIssuanceDescription:
        bundle.localizedString(forKey: "passport_credential_issuance_description")
      case .consentScreenPersonalDataCheckbox:
        bundle.localizedString(forKey: "consent_screen_personal_data_checkbox")
      case .passportScanIntroEnrollmentMethod:
        bundle.localizedString(forKey: "passport_scan_intro_enrollment_method")
      case .passportScanIntroTitle:
        bundle.localizedString(forKey: "passport_scan_intro_title")
      case .passportScanIntroDescription:
        bundle.localizedString(forKey: "passport_scan_intro_description")
      case .passportScanIntroBackButton:
        bundle.localizedString(forKey: "passport_scan_intro_back_button")
      case .passportScanIntroStartButton:
        bundle.localizedString(forKey: "passport_scan_intro_start_button")
      case .passportScanIntroStep1Title:
        bundle.localizedString(forKey: "passport_scan_intro_step_1_title")
      case .passportScanIntroStep1Description:
        bundle.localizedString(forKey: "passport_scan_intro_step_1_description")
      case .passportScanIntroStep2Title:
        bundle.localizedString(forKey: "passport_scan_intro_step_2_title")
      case .passportScanIntroStep2Description:
        bundle.localizedString(forKey: "passport_scan_intro_step_2_description")
      case .passportScanIntroStep3Title:
        bundle.localizedString(forKey: "passport_scan_intro_step_3_title")
      case .passportScanIntroStep3Description:
        bundle.localizedString(forKey: "passport_scan_intro_step_3_description")
      case .passportScanIntroStep4Title:
        bundle.localizedString(forKey: "passport_scan_intro_step_4_title")
      case .passportScanIntroStep5Title:
        bundle.localizedString(forKey: "passport_scan_intro_step_5_title")
      case .passportScanIntroDataDownloadNotice:
        bundle.localizedString(forKey: "passport_scan_intro_data_download_notice")
      case .cdFlashButton:
        bundle.localizedString(forKey: "cd_flash_button")
      case .cdCloseButton:
        bundle.localizedString(forKey: "cd_close_button")
      case .labelClose:
        bundle.localizedString(forKey: "label_close")
      case .labelTurnOn:
        bundle.localizedString(forKey: "label_turn_on")
      case .nfcBodyInitial:
        bundle.localizedString(forKey: "nfc_body_initial")
      case .nfcBodyReading:
        bundle.localizedString(forKey: "nfc_body_reading")
      case .nfcHelpLink:
        bundle.localizedString(forKey: "nfc_help_link")
      case .nfcTitle:
        bundle.localizedString(forKey: "nfc_title")
      case .nfcTitleInitial:
        bundle.localizedString(forKey: "nfc_title_initial")
      case .nfcTitleReading:
        bundle.localizedString(forKey: "nfc_title_reading")
      case .requiredNfcNotSupported:
        bundle.localizedString(forKey: "required_nfc_not_supported")
      case .requiredPermsNotGiven:
        bundle.localizedString(forKey: "required_perms_not_given")
      case .warningAuthenticationFailed:
        bundle.localizedString(forKey: "warning_authentication_failed")
      case .warningClaNotSupported:
        bundle.localizedString(forKey: "warning_cla_not_supported")
      case .warningEnableNfc:
        bundle.localizedString(forKey: "warning_enable_nfc")
      case .mrzErrorInvalidData:
        bundle.localizedString(forKey: "mrz_error_invalid_data")
      case .mrzErrorDocumentExpired:
        bundle.localizedString(forKey: "mrz_error_document_expired")
      case .mrzErrorProcessingFailed:
        bundle.localizedString(forKey: "mrz_error_processing_failed")
      case .mrzCameraPermissionDenied:
        bundle.localizedString(forKey: "mrz_camera_permission_denied")
      case .mrzInitializingCamera:
        bundle.localizedString(forKey: "mrz_initializing_camera")
      case .mrzCameraSetupFailed:
        bundle.localizedString(forKey: "mrz_camera_setup_failed")
      case .mrzUnknownError:
        bundle.localizedString(forKey: "mrz_unknown_error")
      case .mrzDocumentReady:
        bundle.localizedString(forKey: "mrz_document_ready")
      case .mrzScanning:
        bundle.localizedString(forKey: "mrz_scanning")
      case .mrzCameraError:
        bundle.localizedString(forKey: "mrz_camera_error")

      case .nfcErrorTagNotValid:
        bundle.localizedString(forKey: "nfc_error_tag_not_valid")
      case .nfcErrorMoreThanOneTag:
        bundle.localizedString(forKey: "nfc_error_more_than_one_tag")
      case .nfcErrorConnection:
        bundle.localizedString(forKey: "nfc_error_connection")
      case .nfcErrorUserCanceled:
        bundle.localizedString(forKey: "nfc_error_user_canceled")
      case .nfcErrorInvalidMRZKey:
        bundle.localizedString(forKey: "nfc_error_invalid_mrz_key")
      case .nfcErrorUnexpected:
        bundle.localizedString(forKey: "nfc_error_unexpected")
      case .nfcErrorReadingFailed:
        bundle.localizedString(forKey: "nfc_error_reading_failed")
      case .nfcErrorMissingData:
        bundle.localizedString(forKey: "nfc_error_missing_data")
    }
  }
}

fileprivate extension Bundle {
  func localizedString(forKey key: String) -> String {
    let localizedBundle = self.localizedBundle()
    let value = localizedBundle.localizedString(forKey: key, value: nil, table: nil)
    if value == key {
      return defaultBundle().localizedString(forKey: key, value: nil, table: nil)
    } else {
      return value
    }
  }
  func localizedStringWithArguments(forKey key: String, arguments: [CVarArg]) -> String {
    String(format: self.localizedString(forKey: key), locale: nil, arguments: arguments)
  }

  private func localizedBundle() -> Bundle {
    guard let languageCode = Locale.preferredLanguages.first?.components(separatedBy: "-").first,
          let path = self.path(forResource: languageCode, ofType: "lproj"),
          let bundle = Bundle(path: path) else {
      return self
    }
    return bundle
  }

  private func defaultBundle() -> Bundle {
    guard let path = self.path(forResource: "en", ofType: "lproj"),
          let bundle = Bundle(path: path) else {
      return self
    }
    return bundle
  }
}
