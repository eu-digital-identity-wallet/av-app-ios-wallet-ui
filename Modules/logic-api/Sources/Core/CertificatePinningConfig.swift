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

struct CertificatePinningConfig {

  static let pinnedHosts: Set<String> = [
    "issuer.ageverification.dev",
    "issuer.dev.ageverification.dev",
    "verifier.ageverification.dev",
    "verifier.dev.ageverification.dev"
  ]

  // SHA-256 public key hashes
  // Generate: openssl s_client -servername HOST -connect HOST:443 2>/dev/null </dev/null | \
  //   openssl x509 -pubkey -noout | openssl pkey -pubin -outform der | \
  //   openssl dgst -sha256 -binary | openssl enc -base64
  static let publicKeyHashes: [String: Set<String>] = [
    "issuer.ageverification.dev": [
      "1uIbbTksbRP9/hyYImLrEMyz7dYRAOgHRZUAIU6Gp90="
    ],
    "issuer.dev.ageverification.dev": [
      "abOODQ5cP9y7lVM2tQHa1nMMnon7BuGP9D7s8rbAx+Q="
    ],
    "verifier.ageverification.dev": [
      "+t2gC4lN7q4t3jt0NYbxnDktaCs9YdQ21icWr01aN7c="
    ],
    "verifier.dev.ageverification.dev": [
      "sJoCJcqyUdz6RX/qxkDo2mXPhNTwb2TLyQJLEkf02iQ="
    ]
  ]

  static var isEnabled: Bool {
    #if DEBUG
    return false
    #else
    return true
    #endif
  }
}
