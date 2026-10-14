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

struct CertificatePinningConfig {

  static let isEnabled = true

  // SHA-256 public key hashes in SPKI (SubjectPublicKeyInfo) format.
  //
  // Strategy: pin intermediate CA and root SPKI hashes (NOT leaf certificates).
  // Let's Encrypt rotates leaf certificates every ~60-90 days, which would require
  // an app release on each rotation if leaf pins were used. Intermediates (YR1/YR2)
  // are valid until 2028-09-02 and ISRG Root YR until 2032-09-02, so no updates are
  // needed until then. Both YR1 and YR2 are pinned so the app works regardless of
  // which intermediate signs the leaf.
  //
  // Generate: openssl s_client -servername HOST -connect HOST:443 -showcerts 2>/dev/null </dev/null | \
  //           awk '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/{print}' | \
  //           openssl x509 -pubkey -noout | openssl pkey -pubin -outform der | \
  //           openssl dgst -sha256 -binary | openssl enc -base64
  // Verify:   Run scripts/verify-certificate-pinning.sh to verify all hashes

  // Common pin set for all Let's Encrypt-issued issuer domains.
  // Aligned with Android's network_security_config.xml for cross-platform consistency.
  private static let letsEncryptIntermediatePins: [String] = [
    "LoMHBotttiDko50Gi13uXW71eIy7LAttI+rYT8wXF4w=", // Let's Encrypt YR1 (RSA)     - Expires: 2028-09-02
    "nWN7PSep5XDQdge5zK24CnCRXHr3KvzhKEGxsdqCX9E=", // Let's Encrypt YR2 (ECDSA)  - Expires: 2028-09-02
    "fk6IOKit1ild5647BH06ujSIq5XbCgqlbYl6ANhhi88=", // ISRG Root YR                - Expires: 2032-09-02
    "kZwN96eHtZftBWrOZUsd6cA4es80n3NzSk/XtYz2EqQ="  // Let's Encrypt R12 (backup)  - Expires: 2028-09-02
  ]

  private static let pinnedDomains: [String: [String]] = [
    "issuer.ageverification.dev": letsEncryptIntermediatePins,
    "test.issuer.dev.ageverification.dev": letsEncryptIntermediatePins,
    "issuer.dev.ageverification.dev": letsEncryptIntermediatePins,
    "passport.issuer.dev.ageverification.dev": letsEncryptIntermediatePins
  ]

  static func trustKitConfiguration() -> [String: Any] {
    guard isEnabled else { return [:] }

    let domains = pinnedDomains.mapValues { hashes in
      [
        kTSKPublicKeyHashes: hashes,
        kTSKEnforcePinning: true,
        kTSKIncludeSubdomains: false
      ] as [String: Any]
    }

    return [
      kTSKSwizzleNetworkDelegates: false,
      kTSKPinnedDomains: domains
    ]
  }
}
