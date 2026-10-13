#!/bin/bash

# Certificate Pinning Verification Script
# Verifies that pinned intermediate/root SPKI hashes appear in the live
# certificate chain for each pinned domain.
#
# Strategy: pin intermediate + root CAs (not leaf certs) so that Let's Encrypt's
# ~60-day leaf rotations do not require app updates. A domain passes if at
# least one pinned hash matches any certificate in its live chain.
#
# Usage: bash scripts/verify-certificate-pinning.sh

# Do NOT use set -e: the script must check all domains even if one fails.
# The previous version used set -e which aborted the script when
# check_expiry_warning returned non-zero for "expires soon" warnings.
set -u
shopt -s nullglob

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration file path
PINNING_CONFIG="Modules/logic-api/Sources/Core/CertificatePinningConfig.swift"

# Pin-set expiration (shortest-lived pinned intermediate: YR1/YR2/R12 on 2028-09-02)
PIN_SET_EXPIRATION="2028-09-02"
WARN_DAYS=120

# Track overall status
ERRORS=0
WARNINGS=0

# Pinned SPKI hashes (intermediate + root only, no leaf pins)
# These must match the letsEncryptIntermediatePins array in CertificatePinningConfig.swift
PINNED_HASHES=(
  "LoMHBotttiDko50Gi13uXW71eIy7LAttI+rYT8wXF4w=|Let's Encrypt YR1 (RSA)"
  "nWN7PSep5XDQdge5zK24CnCRXHr3KvzhKEGxsdqCX9E=|Let's Encrypt YR2 (ECDSA)"
  "fk6IOKit1ild5647BH06ujSIq5XbCgqlbYl6ANhhi88=|ISRG Root YR"
  "kZwN96eHtZftBWrOZUsd6cA4es80n3NzSk/XtYz2EqQ=|Let's Encrypt R12 (backup)"
)

# Domains to verify (must match pinnedDomains in CertificatePinningConfig.swift)
DOMAINS=(
  "issuer.ageverification.dev"
  "test.issuer.dev.ageverification.dev"
  "issuer.dev.ageverification.dev"
  "passport.issuer.dev.ageverification.dev"
)

echo "========================================="
echo "Certificate Pinning Verification"
echo "========================================="
echo ""
echo "Strategy: intermediate + root CA pinning (no leaf pins)"
echo "Pin-set expiration: $PIN_SET_EXPIRATION (warns at $WARN_DAYS days)"
echo ""

# Function to fetch the full chain and output "hash|subject|expiry" for each cert
get_chain_details() {
    local domain=$1
    local tmpdir
    tmpdir=$(mktemp -d)

    echo | openssl s_client -servername "$domain" -connect "$domain:443" -showcerts 2>/dev/null | \
        awk -v dir="$tmpdir" '
            /-----BEGIN CERTIFICATE-----/ { n++; f = dir "/cert_" n ".pem"; in_cert = 1 }
            in_cert { print > f }
            /-----END CERTIFICATE-----/ { close(f); in_cert = 0 }
        '

    for certfile in "$tmpdir"/cert_*.pem; do
        [ -f "$certfile" ] || continue
        local hash subject expiry
        hash=$(openssl x509 -in "$certfile" -pubkey -noout 2>/dev/null | \
               openssl pkey -pubin -outform der 2>/dev/null | \
               openssl dgst -sha256 -binary | \
               openssl enc -base64)
        subject=$(openssl x509 -in "$certfile" -noout -subject 2>/dev/null | sed 's/subject=//')
        expiry=$(openssl x509 -in "$certfile" -noout -enddate 2>/dev/null | sed 's/notAfter=//')
        echo "${hash}|${subject}|${expiry}"
    done

    rm -rf "$tmpdir"
}

# Function to verify a domain
verify_domain() {
    local domain=$1

    echo -e "${BLUE}Domain: $domain${NC}"
    echo "----------------------------------------"

    echo -n "  Fetching certificate chain... "
    local chain_details
    chain_details=$(get_chain_details "$domain")
    if [ -z "$chain_details" ]; then
        echo -e "${RED}FAILED (no response)${NC}"
        echo ""
        ERRORS=$((ERRORS + 1))
        return
    fi
    echo "done"

    # Extract live chain hashes
    local live_hashes
    live_hashes=$(echo "$chain_details" | cut -d'|' -f1)

    # Check each pinned hash against the live chain
    local matched=0
    echo ""
    echo "  Pinned hashes:"
    for pin_entry in "${PINNED_HASHES[@]}"; do
        local pin_hash="${pin_entry%%|*}"
        local pin_label="${pin_entry##*|}"
        local found=0
        while IFS= read -r live_hash; do
            if [ "$pin_hash" == "$live_hash" ]; then
                found=1
                break
            fi
        done <<< "$live_hashes"

        if [ $found -eq 1 ]; then
            echo -e "    ${GREEN}✓ MATCH${NC}: $pin_hash ($pin_label)"
            matched=1
        else
            echo -e "    ${NC}  -      ${NC}: $pin_hash ($pin_label)"
        fi
    done

    echo ""
    if [ $matched -eq 1 ]; then
        echo -e "  ${GREEN}✓ PASS: at least one pinned hash matches the live chain${NC}"
    else
        echo -e "  ${RED}✗ FAIL: no pinned hash matches the live chain${NC}"
        ERRORS=$((ERRORS + 1))
    fi

    # Print chain details
    echo ""
    echo "  Live certificate chain:"
    local i=1
    while IFS='|' read -r hash subject expiry; do
        local role
        case $i in
            1) role="Leaf         " ;;
            2) role="Intermediate  " ;;
            *) role="CA $i          " ;;
        esac
        echo "    [$role] $subject"
        echo "               SPKI: $hash"
        echo "               Expires: $expiry"
        i=$((i + 1))
    done <<< "$chain_details"

    echo ""
}

# Main verification
echo "Verifying pinned domains..."
echo ""

for domain in "${DOMAINS[@]}"; do
    verify_domain "$domain"
done

# Pin-set expiration check
echo "========================================="
echo "Pin-set Expiration Check"
echo "========================================="
echo ""
echo "  Pin-set expiration date: $PIN_SET_EXPIRATION"
echo "  Warning threshold:       $WARN_DAYS days"

if [[ "$OSTYPE" == "darwin"* ]]; then
    expiry_epoch=$(date -j -f "%Y-%m-%d" "$PIN_SET_EXPIRATION" +%s 2>/dev/null || echo "0")
else
    expiry_epoch=$(date -d "$PIN_SET_EXPIRATION" +%s 2>/dev/null || echo "0")
fi
current_epoch=$(date +%s)
days_until_expiry=$(( ($expiry_epoch - $current_epoch) / 86400 ))

echo "  Days until expiration:   $days_until_expiry"
echo ""

if [ $days_until_expiry -lt 0 ]; then
    echo -e "  ${RED}⚠️  PIN-SET EXPIRED!${NC}"
    echo "  Action required: Rotate pinned intermediates in $PINNING_CONFIG"
    ERRORS=$((ERRORS + 1))
elif [ $days_until_expiry -lt $WARN_DAYS ]; then
    echo -e "  ${YELLOW}⚠️  Pin-set expires in $days_until_expiry days${NC}"
    echo "  Action required: Plan rotation of pinned intermediates"
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "  ${GREEN}✓ Pin-set is valid for another $days_until_expiry days${NC}"
fi

echo ""

# Summary
echo "========================================="
echo "Verification Summary"
echo "========================================="
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All domains verified successfully!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Verification completed with $WARNINGS warning(s)${NC}"
    exit 0
else
    echo -e "${RED}✗ Verification FAILED with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    echo ""
    echo "CRITICAL: Certificate pinning configuration is out of date!"
    echo "Action required: Update $PINNING_CONFIG"
    exit 1
fi
