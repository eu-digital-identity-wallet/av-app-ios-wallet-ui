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
  private static let pinnedDomains: [String: [String]] = [
    "issuer.ageverification.dev": [
      "LlemL1RFChyU/tYsjtLmw3phMJ/d2xQes7XVqkZirU8=", // Leaf
      "AlSQhgtJirc8ahLyekmtX+Iw+v46yPYRLJt9Cq1GlB0="  // Let's Encrypt R13
    ],
    "test.issuer.dev.ageverification.dev": [
      "Os9ReyzMfa0X09LeXRyFP2lDpRllwYIzQiDlkf/ikSw=", // Leaf
      "AlSQhgtJirc8ahLyekmtX+Iw+v46yPYRLJt9Cq1GlB0="  // Let's Encrypt R13
    ],
    "issuer.dev.ageverification.dev": [
      "abOODQ5cP9y7lVM2tQHa1nMMnon7BuGP9D7s8rbAx+Q=", // Leaf
      "kZwN96eHtZftBWrOZUsd6cA4es80n3NzSk/XtYz2EqQ="  // Let's Encrypt R12
    ],
    "passport.issuer.dev.ageverification.dev": [
      "keE5bu9tNclaKTlyp83txr+Gv+7wSetiElUUWT9+fW8=", // Leaf
      "AlSQhgtJirc8ahLyekmtX+Iw+v46yPYRLJt9Cq1GlB0="  // Let's Encrypt R13
    ],
    "verifier.ageverification.dev": [
      "+t2gC4lN7q4t3jt0NYbxnDktaCs9YdQ21icWr01aN7c=", // Leaf
      "aZeR2aS2g2bguhPzWzTQqUq9OCf4tXk7VWrF6R/zJkM="  // GeoTrust CA
    ],
    "verifier.dev.ageverification.dev": [
      "sJoCJcqyUdz6RX/qxkDo2mXPhNTwb2TLyQJLEkf02iQ=", // Leaf
      "aZeR2aS2g2bguhPzWzTQqUq9OCf4tXk7VWrF6R/zJkM="  // GeoTrust CA
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
