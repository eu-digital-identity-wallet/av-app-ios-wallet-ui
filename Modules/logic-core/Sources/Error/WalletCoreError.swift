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
import logic_resources

public enum WalletCoreError: LocalizedError, Equatable {
  case unableFetchDocuments
  case unableFetchDocument
  case missingPid
  case unableToIssueAndStore
  case missingMetadata
  case transactionCodeFormat(Int, Int)
  case unableToPresentAndShare
  case unableToFetchTransactionLog

  public var errorDescription: String? {
    return switch self {
    case .unableFetchDocuments:
      LocalizableStringKey.issuanceDocumentOfferErrorNoDocument.toString
    case .unableFetchDocument:
      LocalizableStringKey.issuanceDocumentOfferErrorNoDocument.toString
    case .missingPid:
      LocalizableStringKey.issuanceDocumentOfferErrorMissingPidText.toString
    case .unableToIssueAndStore:
      LocalizableStringKey.issuanceGenericError.toString
    case .missingMetadata:
      LocalizableStringKey.issuanceGenericError.toString
    case .transactionCodeFormat(let arg1, let arg2):
        LocalizableStringKey.issuanceDocumentOfferErrorInvalidTxcodeFormat(arg1, arg2).toString
    case .unableToPresentAndShare:
      LocalizableStringKey.issuanceDocumentOfferErrorUnableToPresentAndShare.toString
    case .unableToFetchTransactionLog:
      LocalizableStringKey.issuanceGenericError.toString
    }
  }
}
