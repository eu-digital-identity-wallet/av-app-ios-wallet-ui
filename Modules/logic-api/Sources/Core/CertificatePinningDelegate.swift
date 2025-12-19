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
import CommonCrypto
import logic_resources

final class CertificatePinningDelegate: NSObject, URLSessionDelegate, @unchecked Sendable {

  func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
  ) {
    guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
          let serverTrust = challenge.protectionSpace.serverTrust
    else {
      completionHandler(.performDefaultHandling, nil)
      return
    }

    let host = challenge.protectionSpace.host

    guard CertificatePinningConfig.isEnabled,
          CertificatePinningConfig.pinnedHosts.contains(host),
          let expectedHashes = CertificatePinningConfig.publicKeyHashes[host]
    else {
      completionHandler(.performDefaultHandling, nil)
      return
    }

    var error: CFError?
    guard SecTrustEvaluateWithError(serverTrust, &error) else {
      log("Certificate chain validation failed for \(host)", level: .error)
      completionHandler(.cancelAuthenticationChallenge, nil)
      return
    }

    let serverHashes = extractPublicKeyHashes(from: serverTrust)

    if !expectedHashes.isDisjoint(with: serverHashes) {
      log("Certificate pinning succeeded for \(host)", level: .debug)
      completionHandler(.useCredential, URLCredential(trust: serverTrust))
    } else {
      log("Certificate pinning failed for \(host). Expected: \(expectedHashes), Got: \(serverHashes)", level: .error)
      completionHandler(.cancelAuthenticationChallenge, nil)
    }
  }

  private func extractPublicKeyHashes(from trust: SecTrust) -> Set<String> {
    var hashes = Set<String>()

    guard let certificateChain = SecTrustCopyCertificateChain(trust) as? [SecCertificate] else {
      return hashes
    }

    for certificate in certificateChain {
      if let hash = extractPublicKeyHash(from: certificate) {
        hashes.insert(hash)
      }
    }

    return hashes
  }

  private func extractPublicKeyHash(from certificate: SecCertificate) -> String? {
    guard let publicKey = SecCertificateCopyKey(certificate) else {
      return nil
    }

    var error: Unmanaged<CFError>?
    guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, &error) as Data? else {
      return nil
    }

    var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    publicKeyData.withUnsafeBytes {
      _ = CC_SHA256($0.baseAddress, CC_LONG(publicKeyData.count), &hash)
    }

    return Data(hash).base64EncodedString()
  }
}
