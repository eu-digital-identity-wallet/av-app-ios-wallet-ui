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

public protocol NetworkSessionProvider: Sendable {
  var urlSession: URLSession { get }
}

final class NetworkSessionProviderImpl: NetworkSessionProvider {

  let urlSession: URLSession
  private let pinningDelegate: CertificatePinningDelegate

  init() {
    self.pinningDelegate = CertificatePinningDelegate()

    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 300

    self.urlSession = URLSession(
      configuration: configuration,
      delegate: pinningDelegate,
      delegateQueue: nil
    )
  }
}
