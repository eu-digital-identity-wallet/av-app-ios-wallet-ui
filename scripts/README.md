# Scripts

This directory contains utility scripts for the Age Verification Wallet project.

## verify-certificate-pinning.sh

Verifies that all pinned certificate hashes in the iOS app match the actual certificates on the servers.

### Usage

```bash
./scripts/verify-certificate-pinning.sh
```

### What it checks

- Connects to each pinned domain (issuer servers)
- Extracts both leaf and issuer certificates
- Computes SHA-256 hashes of certificate public keys
- Compares actual hashes against expected values in config
- Checks certificate expiry dates
- Warns about certificates expiring within 60 days

### Exit codes

- `0`: All certificates verified successfully (or only warnings)
- `1`: Critical errors found (mismatched hashes or expired certificates)

### Updating certificate hashes

If the script reports a mismatch, update the hashes in:
```
Modules/logic-api/Sources/Core/CertificatePinningConfig.swift
```

To manually get a certificate hash:
```bash
echo | openssl s_client -servername DOMAIN -connect DOMAIN:443 2>/dev/null </dev/null | \
  openssl x509 -pubkey -noout | \
  openssl pkey -pubin -outform der | \
  openssl dgst -sha256 -binary | \
  openssl enc -base64
```
