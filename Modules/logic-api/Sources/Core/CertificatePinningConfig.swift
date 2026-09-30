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

  // SHA-256 public key hashes in SPKI (SubjectPublicKeyInfo) format
  // Generate: openssl s_client -servername HOST -connect HOST:443 2>/dev/null </dev/null | \
  //           openssl x509 -pubkey -noout | openssl pkey -pubin -outform der | \
  //           openssl dgst -sha256 -binary | openssl enc -base64
  // Verify:   Run scripts/verify-certificate-pinning.sh to verify all hashes
  private static let pinnedDomains: [String: [String]] = [
    "issuer.ageverification.dev": [
      "sFgBVnT8BKa5i4T4urfAZHLTtmop/1ji7ztmJ9R1Xrc=", // Leaf - Expires: 2026-11-02
      "LoMHBotttiDko50Gi13uXW71eIy7LAttI+rYT8wXF4w="  // Let's Encrypt YR1 - Expires: 2028-09-02
    ],
    "test.issuer.dev.ageverification.dev": [
      "667G62IrYDxVZgIzaPGg8RoI3cUtv04l5yTN8AykQAg=", // Leaf - Expires: 2026-11-07
      "LoMHBotttiDko50Gi13uXW71eIy7LAttI+rYT8wXF4w="  // Let's Encrypt YR1 - Expires: 2028-09-02
    ],
    "issuer.dev.ageverification.dev": [
      "bxuSBX2j8ByZEqS+0SaHAOTB0+3FbbKdHa0e7MAE9PA=", // Leaf - Expires: 2026-11-14
      "nWN7PSep5XDQdge5zK24CnCRXHr3KvzhKEGxsdqCX9E="  // Let's Encrypt YR2 - Expires: 2028-09-02
    ],
    "passport.issuer.dev.ageverification.dev": [
      "nXiBF9Mrr4gJnsfRm0F6STLWueKcH1LIRDeNAu/AijE=", // Leaf - Expires: 2026-11-07
      "nWN7PSep5XDQdge5zK24CnCRXHr3KvzhKEGxsdqCX9E="  // Let's Encrypt YR2 - Expires: 2028-09-02
    ]
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
