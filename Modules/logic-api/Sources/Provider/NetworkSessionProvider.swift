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
import TrustKit
import logic_resources

public protocol NetworkSessionProvider: Sendable {
  var urlSession: URLSession { get }
}

private enum TrustKitInitializer {
  static let shared: Bool = {
    let config = CertificatePinningConfig.trustKitConfiguration()
    if !config.isEmpty {
      TrustKit.initSharedInstance(withConfiguration: config)

      TrustKit.sharedInstance().pinningValidatorCallback = { result, hostname, _ in
        switch result.finalTrustDecision {
        case .shouldAllowConnection:
          log("Certificate pinning succeeded for \(hostname)", level: .debug)
        case .shouldBlockConnection:
          log("Certificate pinning FAILED for \(hostname): \(result.evaluationResult)", level: .error)
        case .domainNotPinned:
          log("Domain not pinned: \(hostname)", level: .debug)
        @unknown default:
          break
        }
      }
    }
    return true
  }()
}

private final class PinningDelegate: NSObject, URLSessionDelegate, @unchecked Sendable {
  func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
  ) {
    if TrustKit.sharedInstance().pinningValidator.handle(challenge, completionHandler: completionHandler) == false {
      completionHandler(.performDefaultHandling, nil)
    }
  }
}

final class NetworkSessionProviderImpl: NetworkSessionProvider {

  let urlSession: URLSession
  private let delegate = PinningDelegate()

  init() {
    // Initialize TrustKit once per app lifecycle (Swift guarantees thread-safe static let initialization)
    _ = TrustKitInitializer.shared

    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 300

    self.urlSession = URLSession(
      configuration: configuration,
      delegate: delegate,
      delegateQueue: nil
    )
  }
}
