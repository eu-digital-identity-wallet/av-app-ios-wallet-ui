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
      "kYirK0neGc3RSMFJHqxvZwVox0pg7KwThB8nOjSrsec=", // Leaf - Expires: 2026-09-02
      "LoMHBotttiDko50Gi13uXW71eIy7LAttI+rYT8wXF4w="  // Let's Encrypt YR1 - Expires: 2027-03-12
    ],
    "test.issuer.dev.ageverification.dev": [
      "fSmGMVbBf12HnesWiAAVaQEkcpelMBrxdmrJAGpk/ew=", // Leaf - Expires: 2026-09-07
      "LoMHBotttiDko50Gi13uXW71eIy7LAttI+rYT8wXF4w="  // Let's Encrypt YR1 - Expires: 2027-03-12
    ],
    "issuer.dev.ageverification.dev": [
      "kLSOVQB5XnJ7RxpZluD7dinfCApcGomiQMbmuTVLAbc=", // Leaf - Expires: 2026-07-16
      "kZwN96eHtZftBWrOZUsd6cA4es80n3NzSk/XtYz2EqQ="  // Let's Encrypt R12 - Expires: 2027-03-12
    ],
    "passport.issuer.dev.ageverification.dev": [
      "pRm//hr2npxXsIkhvYKMtyDg7dadwDgcuQOHODQvaHs=", // Leaf - Expires: 2026-09-07
      "nWN7PSep5XDQdge5zK24CnCRXHr3KvzhKEGxsdqCX9E="  // Let's Encrypt YR2 - Expires: 2027-03-12
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
