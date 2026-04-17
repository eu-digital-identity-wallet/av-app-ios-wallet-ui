/*
 * Copyright (c) 2026 European Commission
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

public enum PinHasher {

  private static let saltLength = 16
  private static let derivedKeyLength = 32
  private static let iterations: UInt32 = 600_000

  public static func hash(pin: String) -> String {
    let salt = generateSalt()
    let derived = deriveKey(pin: pin, salt: salt)
    return "\(salt.hexString):\(derived.hexString)"
  }

  public static func verify(pin: String, againstStored stored: String) -> Bool {
    guard let (salt, expectedHash) = parse(stored) else {
      return false
    }
    let derived = deriveKey(pin: pin, salt: salt)
    return constantTimeEqual(derived, expectedHash)
  }

  // MARK: - Private

  private static func generateSalt() -> Data {
    var bytes = [UInt8](repeating: 0, count: saltLength)
    let status = SecRandomCopyBytes(kSecRandomDefault, saltLength, &bytes)
    precondition(status == errSecSuccess, "Failed to generate random salt")
    return Data(bytes)
  }

  private static func deriveKey(pin: String, salt: Data) -> Data {
    let pinData = Array(pin.utf8)
    var derived = [UInt8](repeating: 0, count: derivedKeyLength)

    let status = salt.withUnsafeBytes { saltBuffer in
      CCKeyDerivationPBKDF(
        CCPBKDFAlgorithm(kCCPBKDF2),
        pinData,
        pinData.count,
        saltBuffer.baseAddress!.assumingMemoryBound(to: UInt8.self),
        salt.count,
        CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
        iterations,
        &derived,
        derivedKeyLength
      )
    }
    precondition(status == kCCSuccess, "PBKDF2 derivation failed")

    return Data(derived)
  }

  private static func parse(_ stored: String) -> (salt: Data, hash: Data)? {
    let parts = stored.split(separator: ":", maxSplits: 1)
    guard parts.count == 2,
          let salt = Data(hexString: String(parts[0])),
          let hash = Data(hexString: String(parts[1])),
          salt.count == saltLength,
          hash.count == derivedKeyLength else {
      return nil
    }
    return (salt, hash)
  }

  private static func constantTimeEqual(_ lhs: Data, _ rhs: Data) -> Bool {
    guard lhs.count == rhs.count else { return false }
    var result: UInt8 = 0
    for (a, b) in zip(lhs, rhs) {
      result |= a ^ b
    }
    return result == 0
  }
}

// MARK: - Data Hex Helpers

private extension Data {
  var hexString: String {
    map { String(format: "%02x", $0) }.joined()
  }

  init?(hexString: String) {
    guard hexString.count.isMultiple(of: 2) else { return nil }
    var data = Data(capacity: hexString.count / 2)
    var index = hexString.startIndex
    while index < hexString.endIndex {
      let nextIndex = hexString.index(index, offsetBy: 2)
      guard let byte = UInt8(hexString[index..<nextIndex], radix: 16) else {
        return nil
      }
      data.append(byte)
      index = nextIndex
    }
    self = data
  }
}
