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

import logic_ui
import logic_core
import Foundation

public struct DocumentEnrollmentUiConfig: UIConfigType, Equatable, Sendable {

  public let mrzKey: String?
  public let documentData: DocumentData?
  public let configId: String?
  public let docTypeIdentifier: DocumentTypeIdentifier?

  public var log: String {
    var logString = ""
    if let mrzKey = mrzKey {
      logString += "mrzKey: \(mrzKey.prefix(4))..."
    }
    if documentData != nil {
      logString += " hasDocumentData: true"
    }
    return logString.isEmpty ? "empty" : logString
  }

  public init(
    mrzKey: String? = nil,
    documentData: DocumentData? = nil,
    configId: String? = nil,
    docTypeIdentifier: DocumentTypeIdentifier? = nil
  ) {
    self.mrzKey = mrzKey
    self.documentData = documentData
    self.configId = configId
    self.docTypeIdentifier = docTypeIdentifier
  }
}

public extension DocumentEnrollmentUiConfig {

  struct DocumentData: Equatable, Sendable {
    public let photo: Data?
    public let birthDate: String?
    public let expiryDate: String?

    public init(photo: Data?, birthDate: String?, expiryDate: String?) {
      self.photo = photo
      self.birthDate = birthDate
      self.expiryDate = expiryDate
    }
  }
}
