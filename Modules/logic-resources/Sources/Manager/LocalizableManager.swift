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
        //    case .space:
        //      " "
        //    case .search:
        //      bundle.localizedString(forKey: "search")
        //    case .genericErrorTitle:
        //      bundle.localizedString(forKey: "generic_error_title")
        //    case .genericErrorDesc:
        //      bundle.localizedString(forKey: "generic_error_description")
        //    case .biometryOpenSettings:
        //      bundle.localizedString(forKey: "biometry_open_settings")
        //    case .invalidQuickPin:
        //      bundle.localizedString(forKey: "invalid_quick_pin")
        //    case .tryAgain:
        //      bundle.localizedString(forKey: "try_again")
        //    case .shareButton:
        //      bundle.localizedString(forKey: "share_button")
        //    case .cancelButton:
        //      bundle.localizedString(forKey: "cancel_button")
        //    case .requestDataCaption:
        //      bundle.localizedString(forKey: "request_data_share_caption")
        //    case .requestDataInfoNotice:
        //      bundle.localizedString(forKey: "request_data_info_notice")
        //    case .requestDataTitle(let args):
        //      bundle.localizedStringWithArguments(forKey: "request_data_share_title", arguments: args)
        //    case .documentAdded:
        //      bundle.localizedString(forKey: "document_added")
        //    case .requestDataSheetCaption:
        //      bundle.localizedString(forKey: "request_data_sheet_caption")
        //    case .okButton:
        //      bundle.localizedString(forKey: "ok_button")
        //    case .shareDataReview:
        //      bundle.localizedString(forKey: "share_data_review_title")
        //    case .success:
        //      bundle.localizedString(forKey: "success")
        //    case .successfullySharedFollowingInformation:
        //      bundle.localizedString(forKey: "successfully_shared_following_information")
        //    case .incompleteRequestDataSelection:
        //      bundle.localizedString(forKey: "incomplete_request_data_selecting")
        //    case .addDoc:
        //      bundle.localizedString(forKey: "add_doc")
        //    case .welcomeBack(let args):
        //      bundle.localizedStringWithArguments(forKey: "welcome_back", arguments: args)
        //    case .viewDocumentDetails:
        //      bundle.localizedString(forKey: "view_document_details")
        //    case .pleaseWait:
        //      bundle.localizedString(forKey: "please_wait")
        //    case .requestDataShareQuickPinCaption:
        //      bundle.localizedString(forKey: "request_data_share_quick_pin_caption")
        //    case .requestDataShareBiometryCaption:
        //      bundle.localizedString(forKey: "request_data_share_biometry_caption")
        //    case .addDocumentTitle:
        //      bundle.localizedString(forKey: "add_document_title")
        //    case .addDocumentRequest:
        //      bundle.localizedString(forKey: "add_document_request")
        //    case .addDocumentSubtitle:
        //      bundle.localizedString(forKey: "add_document_subtitle")
        //    case .proximityConnectivityCaption:
        //      bundle.localizedString(forKey: "proxmity_connectivity_caption")
        //    case .unavailableField:
        //      bundle.localizedString(forKey: "unavailable_field")
        //    case .requestDataVerifiedEntity:
        //      bundle.localizedString(forKey: "request_data_verified_entity")
        //    case .requestDataVerifiedEntityMessage:
        //      bundle.localizedString(forKey: "request_data_verified_entity_message")
        //    case .changeQuickPinOption:
        //      bundle.localizedString(forKey: "change_quick_pin_option")
        //    case .quickPinSetTitle:
        //      bundle.localizedString(forKey: "quick_pin_set_title")
        //    case .quickPinSetCaptionOne:
        //      bundle.localizedString(forKey: "quick_pin_set_step_one_caption")
        //    case .quickPinSetCaptionTwo:
        //      bundle.localizedString(forKey: "quick_pin_set_step_two_caption")
        //    case .quickPinNextButton:
        //      bundle.localizedString(forKey: "quick_pin_next_button")
        //    case .quickPinConfirmButton:
        //      bundle.localizedString(forKey: "quick_pin_confirm_button")
        //    case .quickPinSetSuccess:
        //      bundle.localizedString(forKey: "quick_pin_set_success")
        //    case .loginTitle:
        //      bundle.localizedString(forKey: "login_title")
        //    case .loginCaptionQuickPinOnly:
        //      bundle.localizedString(forKey: "login_caption_quick_pin_only")
        //    case .loginCaption:
        //      bundle.localizedString(forKey: "login_caption")
        //    case .quickPinSetSuccessButton:
        //      bundle.localizedString(forKey: "quick_pin_set_success_button")
        //    case .quickPinDoNotMatch:
        //      bundle.localizedString(forKey: "quick_pin_dont_match")
        //    case .quickPinUpdateTitle:
        //      bundle.localizedString(forKey: "quick_pin_update_title")
        //    case .quickPinUpdateCaptionOne:
        //      bundle.localizedString(forKey: "quick_pin_update_step_one_caption")
        //    case .quickPinUpdateCaptionTwo:
        //      bundle.localizedString(forKey: "quick_pin_update_step_two_caption")
        //    case .quickPinUpdateCaptionThree:
        //      bundle.localizedString(forKey: "quick_pin_update_step_three_caption")
        //    case .quickPinUpdateSuccess:
        //      bundle.localizedString(forKey: "quick_pin_update_success")
        //    case .quickPinUpdateSuccessButton:
        //      bundle.localizedString(forKey: "quick_pin_update_success_button")
        //    case .quickPinUpdateCancellationTitle:
        //      bundle.localizedString(forKey: "quick_pin_update_cancellation_title")
        //    case .quickPinUpdateCancellationCaption:
        //      bundle.localizedString(forKey: "quick_pin_update_cancellation_caption")
        //    case .quickPinUpdateCancellationContinue:
        //      bundle.localizedString(forKey: "quick_pin_update_cancellation_continue")
        //    case .successTitlePunctuated:
        //      bundle.localizedString(forKey: "issuance_success_title_punctuated")
        //    case .unknownVerifier:
        //      bundle.localizedString(forKey: "unknown_verifier")
        //    case .unknownIssuer:
        //      bundle.localizedString(forKey: "unknown_issuer")
        //    case .genericIssuer:
        //      bundle.localizedString(forKey: "generic_issuer")
        //    case .yes:
        //      bundle.localizedString(forKey: "yes")
        //    case .no:
        //      bundle.localizedString(forKey: "no")
        //    case .scanQrCode:
        //      bundle.localizedString(forKey: "scan_qr_code")
        //    case .validUntil(let args):
        //      bundle.localizedStringWithArguments(forKey: "valid_until", arguments: args)
        //    case .bleDisabledModalTitle:
        //      bundle.localizedString(forKey: "ble_disabled_modal_title")
        //    case .bleDisabledModalCaption:
        //      bundle.localizedString(forKey: "ble_disabled_modal_content")
        //    case .bleDisabledModalButton:
        //      bundle.localizedString(forKey: "ble_disabled_modal_button")
        //    case .requestDataNoDocument:
        //      bundle.localizedString(forKey: "request_data_no_document")
        //    case .issuanceDetailsDeletionTitle(let args):
        //      bundle.localizedStringWithArguments(forKey: "issuance_details_doc_deletion_title", arguments: args)
        //    case .deleteDocument:
        //      bundle.localizedString(forKey: "delete_document")
        //    case .issuanceDetailsDeletionCaption(let args):
        //      bundle.localizedStringWithArguments(forKey: "issuance_details_doc_deletion_caption", arguments: args)
        //    case .errorUnableFetchDocuments:
        //      bundle.localizedString(forKey: "error_unable_fetch_documents")
        //    case .errorUnableFetchDocument:
        //      bundle.localizedString(forKey: "error_unable_fetch_document")
        //    case .scannerQrTitle:
        //      bundle.localizedString(forKey: "scanner_qr_title")
        //    case .scannerQrCaption:
        //      bundle.localizedString(forKey: "scanner_qr_caption")
        //    case .cameraError:
        //      bundle.localizedString(forKey: "camera_error")
        //    case .missingPid:
        //      bundle.localizedString(forKey: "missing_pid")
        //    case .requestCredentialOfferTitle(let args):
        //      bundle.localizedStringWithArguments(forKey: "request_credential_offer_title", arguments: args)
        //    case .requestCredentialOfferNoDocument:
        //      bundle.localizedString(forKey: "request_credential_offer_no_document")
        //    case .unableToIssueAndStore:
        //      bundle.localizedString(forKey: "unable_to_issue_and_store_documents")
        //    case .missingMetadata:
        //      bundle.localizedString(forKey: "missing_metadata")
        //    case .issueButton:
        //      bundle.localizedString(forKey: "issue_button")
        //    case .issuanceCodeTitle(let args):
        //      bundle.localizedStringWithArguments(forKey: "issuance_code_title", arguments: args)
        //    case .issuanceCodeCaption(let args):
        //      bundle.localizedStringWithArguments(forKey: "issuance_code_caption", arguments: args)
        //    case .transactionCodeFormatError(let args):
        //      bundle.localizedStringWithArguments(forKey: "transaction_code_format_error", arguments: args)
        //    case .inProgress:
        //      bundle.localizedString(forKey: "in_progress")
        //    case .scopedIssuanceSuccessDeferredCaption:
        //      bundle.localizedString(forKey: "scoped_issuance_success_deferred_caption")
        //    case .scopedIssuanceSuccessDeferredCaptionDocName(let args):
        //      bundle.localizedStringWithArguments(forKey: "scoped_issuance_success_deferred_caption_docname", arguments: args)
        //    case .scopedIssuanceSuccessDeferredCaptionDocNameAndIssuer(let args):
        //      bundle.localizedStringWithArguments(forKey: "scoped_issuance_success_deferred_caption_docname_and_issuer_name", arguments: args)
        //    case .issuanceSuccessDeferredCaption(let args):
        //      bundle.localizedStringWithArguments(forKey: "issuance_success_deferred_caption", arguments: args)
        //    case .issuanceFailed:
        //      bundle.localizedString(forKey: "issuance_failed")
        //    case .pending:
        //      bundle.localizedString(forKey: "pending")
        //    case .deferredDocumentsIssuedModalTitle:
        //      bundle.localizedString(forKey: "deferred_document_issued_modal_title")
        //    case .defferedDocumentsIssuedModalCaption:
        //      bundle.localizedString(forKey: "deferred_document_issued_modal_caption")
        //    case .retrieveLogs:
        //      bundle.localizedString(forKey: "retrieve_logs")
        //    case .qrScanInformativeText:
        //      bundle.localizedString(forKey: "qr_scan_informative_text")
        //    case .unableToPresentAndShare:
        //      bundle.localizedString(forKey: "error_unable_present_documents")
        //    case .signDocument:
        //      bundle.localizedString(forKey: "sign_document")
        //    case .signDocumentSubtitle:
        //      bundle.localizedString(forKey: "sign_document_subtitle")
        //    case .selectDocument:
        //      bundle.localizedString(forKey: "select_document")
        //    case .itemNotFoundInStorage:
        //      bundle.localizedString(forKey: "item_not_found_in_storage")
        //    case .itemsNotFoundInStorage:
        //      bundle.localizedString(forKey: "items_not_found_in_storage")
        //    case .home:
        //      bundle.localizedString(forKey: "home")
        //    case .transactions:
        //      bundle.localizedString(forKey: "transactions")
        //    case .documents:
        //      bundle.localizedString(forKey: "documents")
        //    case .authenticateAuthoriseTransactions:
        //      bundle.localizedString(forKey: "authenticate_authorise_transactions")
        //    case .electronicallySignDigitalDocuments:
        //      bundle.localizedString(forKey: "electronically_sign_digital_documents")
        //    case .learnMore:
        //      bundle.localizedString(forKey: "learn_more")
        //    case .chooseFromList:
        //      bundle.localizedString(forKey: "choose_from_list")
        //    case .chooseFromListTitle:
        //      bundle.localizedString(forKey: "choose_from_list_title")
        //    case .addDocumentsToWallet:
        //      bundle.localizedString(forKey: "add_documents_to_wallet")
        //    case .details:
        //      bundle.localizedString(forKey: "details")
        //    case .dataSharingRequest:
        //      bundle.localizedString(forKey: "data_sharing_request")
        //    case .dataShared:
        //      bundle.localizedString(forKey: "data_shared")
        //    case .doneButton:
        //      bundle.localizedString(forKey: "done_button")
        //    case .dataSharingTitle:
        //      bundle.localizedString(forKey: "data_sharing_title")
        //    case .close:
        //      bundle.localizedString(forKey: "close")
        //    case .trustedRelyingParty:
        //      bundle.localizedString(forKey: "trusted_relying_party")
        //    case .trustedRelyingPartyDescription:
        //      bundle.localizedString(forKey: "trusted_relying_party_description")
        //    case .issuerWantWalletAddition:
        //      bundle.localizedString(forKey: "issuer_want_wallet_addition")
        //    case .filterByIssuer:
        //      bundle.localizedString(forKey: "filter_by_issuer")
        //    case .alertAccessOnlineServices:
        //      bundle.localizedString(forKey: "alert_access_online_services")
        //    case .alertAccessOnlineServicesMessage:
        //      bundle.localizedString(forKey: "alert_access_online_services_message")
        //    case .alertSignDocumentsSafely:
        //      bundle.localizedString(forKey: "alert_sign_documents_safely")
        //    case .alertSignDocumentsSafelyMessage:
        //      bundle.localizedString(forKey: "alert_sign_documents_safely_message")
        //    case .authenticate:
        //      bundle.localizedString(forKey: "authenticate")
        //    case .inPerson:
        //      bundle.localizedString(forKey: "in_person")
        //    case .online:
        //      bundle.localizedString(forKey: "Online")
        //    case .savedToFavorites:
        //      bundle.localizedString(forKey: "saved_to_favorites")
        //    case .succesfullyAddedFollowingToWallet:
        //      bundle.localizedString(forKey: "succesfully_added_following_to_wallet")
        //    case .removedFromFavorites:
        //      bundle.localizedString(forKey: "removed_from_favorites")
        //    case .savedToFavoritesMessage:
        //      bundle.localizedString(forKey: "saved_to_favorites_message")
        //    case .removedFromFavoritesMessages:
        //      bundle.localizedString(forKey: "removed_from_favorites_messages")
        //    case .scannerQrTitleIssuing:
        //      bundle.localizedString(forKey: "scanner_qr_title_issuing")
        //    case .scannerQrTitlePresentation:
        //      bundle.localizedString(forKey: "scanner_qr_title_presentation")
        //    case .scannerQrCaptionIssuing:
        //      bundle.localizedString(forKey: "scanner_qr_caption_issuing")
        //    case .scannerQrCaptionPresentation:
        //      bundle.localizedString(forKey: "scanner_qr_caption_presentation")
        //    case .quickPinEnterPin:
        //      bundle.localizedString(forKey: "quick_pin_enter_a_pin")
        //    case .quickPinConfirmPin:
        //      bundle.localizedString(forKey: "quick_pin_confirm_pin")
        //    case .biometryConfirmRequest:
        //      bundle.localizedString(forKey: "biometry_confirm_request")
        //    case .viewDetails:
        //      bundle.localizedString(forKey: "view_details")
        //    case .requestsTheFollowing:
        //      bundle.localizedString(forKey: "requests_the_following")
        //    case .walletIsSecured:
        //      bundle.localizedString(forKey: "wallet_is_secured")
        //    case .noResults:
        //      bundle.localizedString(forKey: "no_results")
        //    case .noResultsDocumentsDescription:
        //      bundle.localizedString(forKey: "no_results_documents_description")
        //    case .noResultsTransactionsDescription:
        //      bundle.localizedString(forKey: "no_results_transactions_description")
        //    case .proximityConnectionBleDescription:
        //      bundle.localizedString(forKey: "proximity_connection_ble_description")
        //    case .filters:
        //      bundle.localizedString(forKey: "filters")
        //    case .sortByIssuedDateSectionTitle:
        //      bundle.localizedString(forKey: "sort_by_issued_date")
        //    case .showResults:
        //      bundle.localizedString(forKey: "show_results")
        //    case .reset:
        //      bundle.localizedString(forKey: "reset")
        //    case .all:
        //      bundle.localizedString(forKey: "all")
        //    case .descending:
        //      bundle.localizedString(forKey: "descending")
        //    case .ascending:
        //      bundle.localizedString(forKey: "ascending")
        //    case .selectExpiryPeriod:
        //      bundle.localizedString(forKey: "expiry_period")
        //    case .filterByState:
        //      bundle.localizedString(forKey: "filter_by_state")
        //    case .sortBy:
        //      bundle.localizedString(forKey: "sort_by")
        //    case .deleteDocumentConfirmDialog:
        //      bundle.localizedString(forKey: "delete_document_confirm_dialog")
        //    case .defaultLabel:
        //      bundle.localizedString(forKey: "default")
        //    case .valid:
        //      bundle.localizedString(forKey: "valid")
        //    case .revoke:
        //      bundle.localizedString(forKey: "revoke")
        //    case .expired:
        //      bundle.localizedString(forKey: "expired")
        //    case .dateIssued:
        //      bundle.localizedString(forKey: "date_issued")
        //    case .expiryDate:
        //      bundle.localizedString(forKey: "expiry_date")
        //    case .nextSevenDays:
        //      bundle.localizedString(forKey: "next_seven_days")
        //    case .nextThirtyDays:
        //      bundle.localizedString(forKey: "next_thirty_days")
        //    case .beyondThiryDays:
        //      bundle.localizedString(forKey: "beyond_thirty_days")
        //    case .beforeToday:
        //      bundle.localizedString(forKey: "before_today")
        //    case .issuanceRequest:
        //      bundle.localizedString(forKey: "issuance_request")
        //    case .myEuWallet:
        //      bundle.localizedString(forKey: "My EU Wallet")
        //    case .categoryGovernment:
        //      bundle.localizedString(forKey: "category_government")
        //    case .categoryHealth:
        //      bundle.localizedString(forKey: "category_health")
        //    case .categoryEducation:
        //      bundle.localizedString(forKey: "category_education")
        //    case .categoryFinance:
        //      bundle.localizedString(forKey: "category_finance")
        //    case .categoryRetail:
        //      bundle.localizedString(forKey: "category_retail")
        //    case .categoryOther:
        //      bundle.localizedString(forKey: "category_other")
        //    case .categorySocialSecurity:
        //      bundle.localizedString(forKey: "category_social_security")
        //    case .categoryTravel:
        //      bundle.localizedString(forKey: "category_travel")
        //    case .changelog:
        //      bundle.localizedString(forKey: "changelog")
        //    case .orderBy:
        //      bundle.localizedString(forKey: "order_by")
        //    case .filterByCategory:
        //      bundle.localizedString(forKey: "filter_by_category")
        //    case .searchDocuments:
        //      bundle.localizedString(forKey: "search_documents")
        //    case .searchTransactions:
        //      bundle.localizedString(forKey: "search_transactions")
        //    case .filterByStatus:
        //      bundle.localizedString(forKey: "filter_by_status")
        //    case .completed:
        //      bundle.localizedString(forKey: "completed")
        //    case .failed:
        //      bundle.localizedString(forKey: "failed")
        //    case .filterByDate:
        //      bundle.localizedString(forKey: "filter_by_date")
        //    case .startDate:
        //      bundle.localizedString(forKey: "start_date")
        //    case .endDate:
        //      bundle.localizedString(forKey: "end_date")
        //    case .relyingParty:
        //      bundle.localizedString(forKey: "relying_party")
        //    case .signedDocuments:
        //      bundle.localizedString(forKey: "signed_documents")
        //    case .transactionInformation:
        //      bundle.localizedString(forKey: "transaction_information")
        //    case .transactionDetailsDataSigned:
        //      bundle.localizedString(forKey: "transaction_details_data_signed")
        //    case .transactionDetailsDataShare:
        //      bundle.localizedString(forKey: "transaction_details_data_shared")
        //    case .transactionDetailsScreenCardDateLabel:
        //      bundle.localizedString(forKey: "transaction_details_screen_card_date_label")
        //    case .transactionDetailsCompleted:
        //      bundle.localizedString(forKey: "transaction_details_completed")
        //    case .or:
        //      bundle.localizedString(forKey: "or")
        //    case .today:
        //      bundle.localizedString(forKey: "today")
        //    case .thisWeek:
        //      bundle.localizedString(forKey: "this_week")
        //    case .unknownDate:
        //      bundle.localizedString(forKey: "unknown_date")
        //    case .minutesAgo(let args):
        //      bundle.localizedStringWithArguments(forKey: "minutes_ago", arguments: args)
        //    case .minuteAgo(let args):
        //      bundle.localizedStringWithArguments(forKey: "minute_ago", arguments: args)
        //    case .transactionDate:
        //      bundle.localizedString(forKey: "transaction_date")
        //    case .filterByType:
        //      bundle.localizedString(forKey: "filter_by_type")
        //    case .presentation:
        //      bundle.localizedString(forKey: "presentation")
        //    case .signing:
        //      bundle.localizedString(forKey: "signing")
        //    case .issuance:
        //      bundle.localizedString(forKey: "issuance")
        //    case .withoutRelyingName:
        //      bundle.localizedString(forKey: "without_relying_name")
        //    case .errorFetchTransactionLog:
        //      bundle.localizedString(forKey: "fetch_error_transaction_log")
        //    case .settings:
        //      bundle.localizedString(forKey: "settings_menu")
        //    case .splashTitle:
        //        bundle.localizedString(forKey: "splash_title")
        //    case .splashSponsorsTitle:
        //        bundle.localizedString(forKey: "splash_sponsors_title")
        //    case .welcomeTitle1:
        //        bundle.localizedString(forKey: "welcome_title_1")
        //    case .welcomePage1:
        //        bundle.localizedString(forKey: "welcome_page_1")
        //    case .welcomeTitle2:
        //        bundle.localizedString(forKey: "welcome_title_2")
        //    case .welcomePage2:
        //        bundle.localizedString(forKey: "welcome_page_2")
        //    case .welcomeTitle3:
        //        bundle.localizedString(forKey: "welcome_title_3")
        //    case .welcomePage3:
        //        bundle.localizedString(forKey: "welcome_page_3")
        //    case .welcomeSkipButton:
        //        bundle.localizedString(forKey: "welcome_screen_skip")
        //    case .onboardingStepWelcome:
        //        bundle.localizedString(forKey: "onboarding_step_1_title")
        //    case .onboardingStepConsent:
        //        bundle.localizedString(forKey: "onboarding_step_2_title")
        //    case .onboardoingStepPin:
        //        bundle.localizedString(forKey: "onboarding_step_3_title")
        //    case .onboardingStepEnrollment:
        //        bundle.localizedString(forKey: "onboarding_step_4_title")
        //    case .consentTitle:
        //        bundle.localizedString(forKey: "consent_title")
        //    case .consentCheckboxLabel1:
        //        bundle.localizedString(forKey: "consent_checkbox_label_1")
        //    case .consentCheckboxLabel2:
        //        bundle.localizedString(forKey: "consent_checkbox_label_2")
        //    case .consentCheckboxLabel3:
        //        bundle.localizedString(forKey: "consent_checkbox_label_3")
        //    case .consentHyperlinkLabel1:
        //        bundle.localizedString(forKey: "consent_hyperlink_label_1")
        //    case .consentHyperlinkLabel2:
        //        bundle.localizedString(forKey: "consent_hyperlink_label_2")
        //    case .consentConfirmButton:
        //        bundle.localizedString(forKey: "consent_screen_confirm_button")
        //    case .quickPinCreateTitle:
        //        bundle.localizedString(forKey: "quick_pin_create_title")
        //    case .quickPinReEnterTitle:
        //        bundle.localizedString(forKey: "quick_pin_create_reenter_title")
        //    case .quickPinCreateSubtitle:
        //        bundle.localizedString(forKey: "quick_pin_create_enter_subtitle")
        //    case .quickPinReEnterSubtitle:
        //        bundle.localizedString(forKey: "quick_pin_create_reenter_subtitle")
        //    case .quickPinTitle:
        //        bundle.localizedString(forKey: "quick_pin_title")
        //    case .verificationStepTitle:
        //        bundle.localizedString(forKey: "onboarding_verification_title")
        //    case .verificationStepDescription:
        //        bundle.localizedString(forKey: "onboarding_verification_description")
        //    case .verificationNationalId:
        //        bundle.localizedString(forKey: "onboarding_verification_national_id")
        //    case .verificationNationalIdDescription:
        //        bundle.localizedString(forKey: "onboarding_verification_national_id_description")
        //    case .landingScreenTitle:
        //        bundle.localizedString(forKey: "landing_screen_title")
        //    case .landingScreenbody:
        //        bundle.localizedString(forKey: "landing_screen_body")
        //    case .europeanUnionLabel1:
        //        bundle.localizedString(forKey: "european_union_label_1")
        //    case .credentialDetailsTitle:
        //        bundle.localizedString(forKey: "credential_details_title")
        //    case .scanTitle:
        //        bundle.localizedString(forKey: "scan_title")
        //    case .biometricSetupTitle:
        //        bundle.localizedString(forKey: "biometric_setup_title")
        //    case .biometricSetupDescription(let arg):
        //        bundle.localizedStringWithArguments(forKey: "biometric_setup_description", arguments: [arg])
        //    case .biometricSetupButton:
        //        bundle.localizedString(forKey: "biometric_setup_enable")
        //    case .biometricSetupSkipButton:
        //        bundle.localizedString(forKey: "biometric_setup_skip")
        //    case .landingCredentialsLeft(let arg):
        //        bundle.localizedStringWithArguments(forKey: "landing_screen_credentials_left", arguments: [arg])
        //    case .addMoreCredentials:
        //        bundle.localizedString(forKey: "landing_screen_add_more")
        //    case .settingsAppInformation:
        //        bundle.localizedString(forKey: "settings_app_information")
        //    case .settingsAppVersion:
        //        bundle.localizedString(forKey: "settings_app_version")
        //    case .settingsCredentials:
        //        bundle.localizedString(forKey: "settings_credentials")
        //    case .settingsDeleteCredentials:
        //        bundle.localizedString(forKey: "settings_delete_credentials")
        //    case .back:
        //      bundle.localizedString(forKey: "back_button_title")
        //    case .quickPinInvalidWithAttempts(let arg):
        //        bundle.localizedStringWithArguments(forKey: "quick_pin_invalid_with_attempts", arguments: [arg])
        //    case .quickPinInvalidLastAttempt:
        //        bundle.localizedString(forKey: "quick_pin_invalid_last_attempt")
        //    case .quickPinLockedOut:
        //        bundle.localizedString(forKey: "quick_pin_locked_out")
        //    case .quickPinLockoutCountdownMinutes(let args):
        //        bundle.localizedStringWithArguments(forKey: "quick_pin_lockout_countdown_minutes", arguments: args)
        //    case .quickPinLockoutCountdownSeconds(let arg):
        //        bundle.localizedStringWithArguments(forKey: "quick_pin_lockout_countdown_seconds", arguments: [arg])
        //    case .quickPinErrorInsecurePin:
        //        bundle.localizedString(forKey: "quick_pin_error_insecure_pin")
        //    case .changeQuickPinCaption:
        //        bundle.localizedString(forKey: "change_quick_pin_caption")
        //    case .changePinDescription:
        //        bundle.localizedString(forKey: "change_pin_description")
        //    case .changePinFirstPinDescription:
        //        bundle.localizedString(forKey: "change_pin_first_pin_description")
        //    case .changePinSecondPinDescription:
        //        bundle.localizedString(forKey: "change_pin_second_pin_description")
        //    case .changePinHelpText:
        //        bundle.localizedString(forKey: "change_pin_help_text")
        //    case .changePinSuccessText:
        //        bundle.localizedString(forKey: "change_pin_success_text")
        //    case .credentialIssuanceTitle:
        //      bundle.localizedString(forKey: "credential_issuance_title")
        //    case .credentialIssuanceDescription:
        //      bundle.localizedString(forKey: "credential_issuance_description")
        //    case .incomplete:
        //      bundle.localizedString(forKey: "incomplete")
        //    case .justNow:
        //      bundle.localizedString(forKey: "just_now")
        //    case .revoked:
        //      bundle.localizedString(forKey: "revoked")
        //    case .documentDetailsRevokedDocumentMessage:
        //      bundle.localizedString(forKey: "document_details_revoked_document_message")
        //    case .revokedModalTitle:
        //      bundle.localizedString(forKey: "revoked_modal_title")
        //    case .revokedModalDescription:
        //      bundle.localizedString(forKey: "revoked_modal_description")
        //    case .transactionDetailsRequestDeletionMessage:
        //      bundle.localizedString(forKey: "transaction_details_eequest_deletion_message")
        //    case .transactionDetailsRequestDeletionButton:
        //      bundle.localizedString(forKey: "transaction_details_eequest_deletion_button")
        //    case .transactionDetailsReportTransactionMessage:
        //      bundle.localizedString(forKey: "transaction_details_report_transaction_message")
        //    case .transactionDetailsReportTransactionButton:
        //      bundle.localizedString(forKey: "transaction_detailsReport_transaction_button")
        //    case .documentDetailsDocumentCredentialsText(let args):
        //      bundle.localizedStringWithArguments(forKey: "document_details_document_credentials_text", arguments: args)
        //    case .documentDetailsDocumentCredentialsMoreInfoText:
        //      bundle.localizedString(forKey: "document_details_document_credentials_more_info_text")
        //    case .documentDetailsDocumentCredentialsExpandedTextSubtitle:
        //      bundle.localizedString(forKey: "document_details_document_credentials_expanded_text_subtitle")
        //    case .documentDetailsDocumentCredentialsExpandedButtonHideText:
        //      bundle.localizedString(forKey: "document_details_document_credentials_expanded_button_hide_text")
        //    case .documentsListCredentialsUsageText(let args):
        //      bundle.localizedStringWithArguments(forKey: "documents_list_credentials_usage_text", arguments: args)
        //    case .expandableDocumentCredentialsIssueButton:
        //      bundle.localizedString(forKey: "expandable_document_credentials_issue_button")
        //    case .issuanceAddDocumentNoOptions:
        //      bundle.localizedString(forKey: "issuance_add_document_no_options")
        //    case .settingsSupport:
        //      bundle.localizedString(forKey: "settings_support")
        //    case .settingsUnlockWithBiometrics:
        //      bundle.localizedString(forKey: "settings_unlock_with_biometrics")
        //    case .settingsDeleteAllProofsOfAttestation:
        //      bundle.localizedString(forKey: "settings_delete_all_proofs_attestation")
        //    case .settingsTermsOfService:
        //      bundle.localizedString(forKey: "settings_terms_of_service")
        //    case .settingsLanguage:
        //      bundle.localizedString(forKey: "settings_language")
        //    case .settingsAboutThisApp:
        //      bundle.localizedString(forKey: "settings_about_this_app")
        //    case .acceptButton:
        //      bundle.localizedString(forKey: "accept_button")
        //    case .proofOfAgeTitle:
        //      bundle.localizedString(forKey: "proof_of_age_title")
        //    case .documentProviderSectionHeader:
        //      bundle.localizedString(forKey: "document_provider_section_header")
        //    case .unknown:
        //      bundle.localizedString(forKey: "unknown")
        //
        //    case .passportIdentificationTitle:
        //        bundle.localizedString(forKey: "passport_identification_title")
        //    case .passportIdentificationDescription:
        //        bundle.localizedString(forKey: "passport_identification_description")
        //    case .passportIdentificationStepFirst:
        //        bundle.localizedString(forKey: "passport_identification_step_first")
        //    case .passportIdentificationStepSecond:
        //        bundle.localizedString(forKey: "passport_identification_step_second")
        //    case .passportIdentificationFooter:
        //        bundle.localizedString(forKey: "passport_identification_footer")
        //    case .passportIdentificationBack:
        //        bundle.localizedString(forKey: "passport_identification_back")
        //    case .passportIdentificationCapture:
        //        bundle.localizedString(forKey: "passport_identification_capture")
        //    case .passportCaptureTitle:
        //        bundle.localizedString(forKey: "passport_capture_title")
        //    case .passportCaptureSubtitle:
        //        bundle.localizedString(forKey: "passport_capture_subtitle")
        //    case .passportIdentification:
        //        bundle.localizedString(forKey: "passport_identification")
        //    case .passportBiometrics:
        //        bundle.localizedString(forKey: "passport_biometrics")
        //    case .passportLiveVideo:
        //        bundle.localizedString(forKey: "passport_live_video")
        //    case .passportBiometricsBack:
        //        bundle.localizedString(forKey: "passport_biometrics_back")
        //    case .passportBiometricsNext:
        //        bundle.localizedString(forKey: "passport_biometrics_next")
        //    case .passportBiometricsContentDescription:
        //        bundle.localizedString(forKey: "passport_biometrics_content_description")
        //    case .passportBiometricsFirstHeader:
        //        bundle.localizedString(forKey: "passport_biometrics_first_header")
        //      case .passportBiometricsFirstDescription:
        //        bundle.localizedString(forKey: "passport_biometrics_first_description")
        //      case .passportBiometricsFirstLink:
        //        bundle.localizedString(forKey: "passport_biometrics_first_link")
        //      case .passportBiometricsVerifyData:
        //        bundle.localizedString(forKey: "passport_biometrics_verify_data")
        //      case .passportBiometricsTryAgain:
        //        bundle.localizedString(forKey: "passport_biometrics_try_again")
        //      case .passportBiometricsPassport:
        //        bundle.localizedString(forKey: "passport_biometrics_passport")
        //      case .passportBiometricsDob:
        //        bundle.localizedString(forKey: "passport_biometrics_dob")
        //      case .passportBiometricsDoe:
        //        bundle.localizedString(forKey: "passport_biometrics_doe")
        //      case .passportBiometricsNoAvailability:
        //        bundle.localizedString(forKey: "passport_biometrics_no_availability")
        //      case .passportBiometricsNoPassportData:
        //        bundle.localizedString(forKey: "passport_biometrics_no_passport_data")
        //      case .passportBiometricsScanCancelled:
        //        bundle.localizedString(forKey: "passport_biometrics_scan_cancelled")
        //      case .passportBiometricsUnknownError:
        //        bundle.localizedString(forKey: "passport_biometrics_unknown_error")
        //      case .passportLiveVideoHeader:
        //        bundle.localizedString(forKey: "passport_live_video_header")
        //      case .passportLiveVideoDescription:
        //        bundle.localizedString(forKey: "passport_live_video_description")
        //      case .passportLiveVideoStepFirst:
        //        bundle.localizedString(forKey: "passport_live_video_step_first")
        //      case .passportLiveVideoStepSecond:
        //        bundle.localizedString(forKey: "passport_live_video_step_second")
        //      case .passportLiveVideoStepThird:
        //        bundle.localizedString(forKey: "passport_live_video_step_third")
        //      case .passportLiveVideoFooter:
        //        bundle.localizedString(forKey: "passport_live_video_footer")
        //      case .passportLiveVideoBack:
        //        bundle.localizedString(forKey: "passport_live_video_back")
        //      case .passportLiveVideoLiveCapture:
        //        bundle.localizedString(forKey: "passport_live_video_live_capture")
        //      case .passportLiveVideoErrorNotProcessed:
        //        bundle.localizedString(forKey: "passport_live_video_error_not_processed")
        //      case .passportLiveVideoErrorNotLive:
        //        bundle.localizedString(forKey: "passport_live_video_error_not_live")
        //      case .passportLiveVideoErrorNotMatching:
        //        bundle.localizedString(forKey: "passport_live_video_error_not_matching")
        //      case .passportValidationErrorExpired:
        //        bundle.localizedString(forKey: "passport_validation_error_expired")
        //      case .passportValidationErrorUnderage:
        //        bundle.localizedString(forKey: "passport_validation_error_underage")
        //      case .passportValidationErrorIncompleteData:
        //        bundle.localizedString(forKey: "passport_validation_error_incomplete_data")
        //      case .passportLiveVideoDownloadingProgress:
        //        bundle.localizedString(forKey: "passport_live_video_downloading_progress")
        //      case .passportCredentialIssuanceTitle:
        //        bundle.localizedString(forKey: "passport_credential_issuance_title")
        //      case .passportCredentialIssuanceDescription:
        //        bundle.localizedString(forKey: "passport_credential_issuance_description")
        //      case .consentScreenPersonalDataCheckbox:
        //        bundle.localizedString(forKey: "consent_screen_personal_data_checkbox")
        //      case .passportScanIntroEnrollmentMethod:
        //        bundle.localizedString(forKey: "passport_scan_intro_enrollment_method")
        //      case .passportScanIntroTitle:
        //        bundle.localizedString(forKey: "passport_scan_intro_title")
        //      case .passportScanIntroDescription:
        //        bundle.localizedString(forKey: "passport_scan_intro_description")
        //      case .passportScanIntroBackButton:
        //        bundle.localizedString(forKey: "passport_scan_intro_back_button")
        //      case .passportScanIntroStartButton:
        //        bundle.localizedString(forKey: "passport_scan_intro_start_button")
        //      case .passportScanIntroStep1Title:
        //        bundle.localizedString(forKey: "passport_scan_intro_step_1_title")
        //      case .passportScanIntroStep1Description:
        //        bundle.localizedString(forKey: "passport_scan_intro_step_1_description")
        //      case .passportScanIntroStep2Title:
        //        bundle.localizedString(forKey: "passport_scan_intro_step_2_title")
        //      case .passportScanIntroStep2Description:
        //        bundle.localizedString(forKey: "passport_scan_intro_step_2_description")
        //      case .passportScanIntroStep3Title:
        //        bundle.localizedString(forKey: "passport_scan_intro_step_3_title")
        //      case .passportScanIntroStep3Description:
        //        bundle.localizedString(forKey: "passport_scan_intro_step_3_description")
        //      case .passportScanIntroStep4Title:
        //        bundle.localizedString(forKey: "passport_scan_intro_step_4_title")
        //      case .passportScanIntroStep5Title:
        //        bundle.localizedString(forKey: "passport_scan_intro_step_5_title")
        //      case .passportScanIntroDataDownloadNotice:
        //        bundle.localizedString(forKey: "passport_scan_intro_data_download_notice")
        //      case .cdFlashButton:
        //        bundle.localizedString(forKey: "cd_flash_button")
        //      case .cdCloseButton:
        //        bundle.localizedString(forKey: "cd_close_button")
        //      case .labelClose:
        //        bundle.localizedString(forKey: "label_close")
        //      case .labelTurnOn:
        //        bundle.localizedString(forKey: "label_turn_on")
        //      case .nfcBodyInitial:
        //        bundle.localizedString(forKey: "nfc_body_initial")
        //      case .nfcBodyReading:
        //        bundle.localizedString(forKey: "nfc_body_reading")
        //      case .nfcHelpLink:
        //        bundle.localizedString(forKey: "nfc_help_link")
        //      case .nfcTitle:
        //        bundle.localizedString(forKey: "nfc_title")
        //      case .nfcTitleInitial:
        //        bundle.localizedString(forKey: "nfc_title_initial")
        //      case .nfcTitleReading:
        //        bundle.localizedString(forKey: "nfc_title_reading")
        //      case .requiredNfcNotSupported:
        //        bundle.localizedString(forKey: "required_nfc_not_supported")
        //      case .requiredPermsNotGiven:
        //        bundle.localizedString(forKey: "required_perms_not_given")
        //      case .warningAuthenticationFailed:
        //        bundle.localizedString(forKey: "warning_authentication_failed")
        //      case .warningClaNotSupported:
        //        bundle.localizedString(forKey: "warning_cla_not_supported")
        //      case .warningEnableNfc:
        //        bundle.localizedString(forKey: "warning_enable_nfc")

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
      case .biometricSetupDescription(let arg):
        bundle.localizedStringWithArguments(forKey: "biometric_setup_description", arguments: [arg])
      case .biometricSetupEnable:
        bundle.localizedString(forKey: "biometric_setup_enable")
      case .biometricSetupSkip:
        bundle.localizedString(forKey: "biometric_setup_skip")
      case .biometricSetupTitle:
        bundle.localizedString(forKey: "biometric_setup_title")
      case .biometricUnknownError:
        bundle.localizedString(forKey: "biometric_unknown_error")
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
      case .genericOk:
        bundle.localizedString(forKey: "generic_ok")
      case .genericOr:
        bundle.localizedString(forKey: "generic_or")
      case .genericScanQr:
        bundle.localizedString(forKey: "generic_scan_qr")
      case .genericSuccess:
        bundle.localizedString(forKey: "generic_success")
      case .genericViewDetails:
        bundle.localizedString(forKey: "generic_view_details")
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
      case .issuanceCodeCaption(let args):
        bundle.localizedStringWithArguments(forKey: "issuance_code_caption", arguments: args)
      case .issuanceCodeTitle(let args):
        bundle.localizedStringWithArguments(forKey: "issuance_code_title", arguments: args)
      case .issuanceDocumentOfferDeferredSuccessDescription(let args):
        bundle.localizedStringWithArguments(forKey: "issuance_document_offer_deferred_success_description", arguments: args)
      case .issuanceDocumentOfferDeferredSuccessPrimaryButtonText:
        bundle.localizedString(forKey: "issuance_document_offer_deferred_success_primary_button_text")
      case .issuanceDocumentOfferDeferredSuccessText:
        bundle.localizedString(forKey: "issuance_document_offer_deferred_success_text")
      case .issuanceDocumentOfferDescription:
        bundle.localizedString(forKey: "issuance_document_offer_description")
      case .issuanceDocumentOfferErrorInvalidTxcodeFormat(let args):
        bundle.localizedStringWithArguments(forKey: "issuance_document_offer_error_invalid_txcode_format", arguments: args)
      case .issuanceDocumentOfferErrorMissingPidText:
        bundle.localizedString(forKey: "issuance_document_offer_error_missing_pid_text")
      case .issuanceDocumentOfferErrorNoDocument:
        bundle.localizedString(forKey: "issuance_document_offer_error_no_document")
      case .issuanceDocumentOfferHeaderMainText:
        bundle.localizedString(forKey: "issuance_document_offer_header_main_text")
      case .issuanceDocumentOfferPrimaryButtonTextAdd:
        bundle.localizedString(forKey: "issuance_document_offer_primary_button_text_add")
      case .issuanceDocumentOfferRelyingPartyDefaultName:
        bundle.localizedString(forKey: "issuance_document_offer_relying_party_default_name")
      case .issuanceDocumentOfferRelyingPartyDescription(let args):
        bundle.localizedStringWithArguments(forKey: "issuance_document_offer_relying_party_description", arguments: args)
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
      case .landingScreenCredentialsLeft(let count):
        bundle.localizedStringWithArguments(forKey: "landing_screen_credentials_left", arguments: [count])
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
      case .onboardingStep1Title:
        bundle.localizedString(forKey: "onboarding_step_1_title")
      case .onboardingStep2Title:
        bundle.localizedString(forKey: "onboarding_step_2_title")
      case .onboardingStep3Title:
        bundle.localizedString(forKey: "onboarding_step_3_title")
      case .onboardingStep4Title:
        bundle.localizedString(forKey: "onboarding_step_4_title")
      case .onboardingVerificationDescription:
        bundle.localizedString(forKey: "onboarding_verification_description")
      case .onboardingVerificationNationalId:
        bundle.localizedString(forKey: "onboarding_verification_national_id")
      case .onboardingVerificationNationalIdDescription:
        bundle.localizedString(forKey: "onboarding_verification_national_id_description")
      case .onboardingVerificationPassportIdCard:
        bundle.localizedString(forKey: "onboarding_verification_passport_id_card")
      case .onboardingVerificationPassportIdCardDescription:
        bundle.localizedString(forKey: "onboarding_verification_passport_id_card_description")
      case .onboardingVerificationTitle:
        bundle.localizedString(forKey: "onboarding_verification_title")
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
      case .passportLiveVideoDownloadingProgress:
        bundle.localizedString(forKey: "passport_live_video_downloading_progress")
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
      case .quickPinChangeEnterNewSubtitle:
        bundle.localizedString(forKey: "quick_pin_change_enter_new_subtitle")
      case .quickPinChangeLockoutCountdownMinutes(let minutes, let seconds):
        bundle.localizedStringWithArguments(forKey: "quick_pin_change_lockout_countdown_minutes", arguments: [minutes, seconds])
      case .quickPinChangeLockoutCountdownSeconds(let seconds):
        bundle.localizedStringWithArguments(forKey: "quick_pin_change_lockout_countdown_seconds", arguments: [seconds])
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
      case .quickPinInvalidWithAttempts(let arg):
        bundle.localizedStringWithArguments(forKey: "quick_pin_invalid_with_attempts", arguments: [arg])
      case .quickPinLockedOut:
        bundle.localizedString(forKey: "quick_pin_locked_out")
      case .quickPinLockoutCountdownMinutes(let minute, let seconds):
        bundle.localizedStringWithArguments(forKey: "quick_pin_lockout_countdown_minutes", arguments: [minute, seconds])
      case .quickPinLockoutCountdownSeconds(let seconds):
        bundle.localizedStringWithArguments(forKey: "quick_pin_lockout_countdown_seconds", arguments: [seconds])
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
      case .requestRelyingPartyDescription(let arg):
        bundle.localizedStringWithArguments(forKey: "request_relying_party_description", arguments: arg)
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

        // Additional ones in iOS
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

        // Extra after merge

      case .itemNotFoundInStorage:
        bundle.localizedString(forKey: "item_not_found_in_storage")
      case .itemsNotFoundInStorage:
        bundle.localizedString(forKey: "items_not_found_in_storage")
      case .unknownVerifier:
        bundle.localizedString(forKey: "unknown_verifier")
      case .requestDataInfoNotice:
        bundle.localizedString(forKey: "request_data_info_notice")
      case .issuanceDocumentOfferErrorUnableToPresentAndShare:
        bundle.localizedString(forKey: "issuance_document_offer_error_unable_to_present_and_share")
      case .issuanceDocumentOfferErrorUnableToFetchTransactionLog:
        bundle.localizedString(forKey: "issuance_document_offer_error_unable_to_fetch_transaction_log")
      case .genericUnknown:
        bundle.localizedString(forKey: "generic_unknown")
      case .requestDataVerifiedEntityMessage:
        bundle.localizedString(forKey: "request_data_verified_entity_message")
      case .openSystemSettings:
        bundle.localizedString(forKey: "open_system_settings") //need to add this new key as well
      case .quickPinChangeHelpText:
        bundle.localizedString(forKey: "quick_pin_change_help_text") // need to add this new key as well (Please avoid using consecutive numbers or birthdays if possible.)
      case .biometricConfirmRequest:
        bundle.localizedString(forKey: "biometric_confirm_request") // Need to add this new key as well ( Confirm request )
      case .proximityConnectivityCaption:
        bundle.localizedString(forKey: "proximity_connectivity_caption")
      case .proximityConnectionBleDescription:
        bundle.localizedString(forKey: "proximity_connection_ble_description")
      case .issuanceDocumentOfferDeferredSuccessDescriptionWithDocAndIssuer(let args):
        bundle.localizedStringWithArguments(forKey: "issuance_document_offer_deferred_success_description_with_doc_and_issuer", arguments: args) // need to add this new key as well -> Your document %@ has been requested from %@. You will be notified when it has been issued to your application.
      case .issuanceDocumentOfferDeferredSuccessDescriptionWithDoc(let args):
        bundle.localizedStringWithArguments(forKey: "issuance_document_offer_deferred_success_description_with_doc", arguments: args) // need to add this new key as well -> Your document %@ has been requested. You will be notified when it has been issued to your application.
      case .documentProviderSectionHeader:
        bundle.localizedString(forKey: "document_provider_section_header") // need to add this new key as well (This information will be shared:)
      case .genericAccept:
        bundle.localizedString(forKey: "generic_accept") // new key to be added as above
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
