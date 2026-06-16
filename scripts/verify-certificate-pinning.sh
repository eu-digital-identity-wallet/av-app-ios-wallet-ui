#!/bin/bash

# Certificate Pinning Verification Script
# Verifies that all pinned certificate hashes match the actual certificates on the servers

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration file path
PINNING_CONFIG="Modules/logic-api/Sources/Core/CertificatePinningConfig.swift"

# Track overall status
ERRORS=0
WARNINGS=0

echo "========================================="
echo "Certificate Pinning Verification"
echo "========================================="
echo ""

# Function to get certificate hash
get_cert_hash() {
    local domain=$1
    echo | openssl s_client -servername "$domain" -connect "$domain:443" -showcerts 2>/dev/null | \
    awk '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/ {print; if (/-----END CERTIFICATE-----/) exit}' | \
    openssl x509 -pubkey -noout 2>/dev/null | \
    openssl pkey -pubin -outform der 2>/dev/null | \
    openssl dgst -sha256 -binary | \
    openssl enc -base64
}

# Function to get issuer certificate hash
get_issuer_hash() {
    local domain=$1
    echo | openssl s_client -servername "$domain" -connect "$domain:443" -showcerts 2>/dev/null | \
    awk 'BEGIN{count=0} /-----BEGIN CERTIFICATE-----/{count++} count==2,/-----END CERTIFICATE-----/ {print; if (/-----END CERTIFICATE-----/ && count==2) exit}' | \
    openssl x509 -pubkey -noout 2>/dev/null | \
    openssl pkey -pubin -outform der 2>/dev/null | \
    openssl dgst -sha256 -binary | \
    openssl enc -base64
}

# Function to get certificate expiry date
get_cert_expiry() {
    local domain=$1
    echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null | \
    openssl x509 -noout -enddate 2>/dev/null | \
    sed 's/notAfter=//'
}

# Function to get issuer certificate expiry date
get_issuer_expiry() {
    local domain=$1
    echo | openssl s_client -servername "$domain" -connect "$domain:443" -showcerts 2>/dev/null | \
    awk 'BEGIN{count=0} /-----BEGIN CERTIFICATE-----/{count++} count==2,/-----END CERTIFICATE-----/ {print; if (/-----END CERTIFICATE-----/ && count==2) exit}' | \
    openssl x509 -noout -enddate 2>/dev/null | \
    sed 's/notAfter=//'
}

# Function to get certificate subject
get_cert_subject() {
    local domain=$1
    echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null | \
    openssl x509 -noout -subject 2>/dev/null | \
    sed 's/subject=//'
}

# Function to get issuer certificate subject
get_issuer_subject() {
    local domain=$1
    echo | openssl s_client -servername "$domain" -connect "$domain:443" -showcerts 2>/dev/null | \
    awk 'BEGIN{count=0} /-----BEGIN CERTIFICATE-----/{count++} count==2,/-----END CERTIFICATE-----/ {print; if (/-----END CERTIFICATE-----/ && count==2) exit}' | \
    openssl x509 -noout -subject 2>/dev/null | \
    sed 's/subject=//'
}

# Function to check if expiry is within N days
check_expiry_warning() {
    local expiry_date=$1
    local warn_days=60

    # Convert expiry date to epoch
    if [[ "$OSTYPE" == "darwin"* ]]; then
        expiry_epoch=$(date -j -f "%b %d %T %Y %Z" "$expiry_date" +%s 2>/dev/null || echo "0")
    else
        expiry_epoch=$(date -d "$expiry_date" +%s 2>/dev/null || echo "0")
    fi

    current_epoch=$(date +%s)
    days_until_expiry=$(( ($expiry_epoch - $current_epoch) / 86400 ))

    if [ $days_until_expiry -lt 0 ]; then
        echo "EXPIRED"
        return 2
    elif [ $days_until_expiry -lt $warn_days ]; then
        echo "EXPIRES_SOON:$days_until_expiry"
        return 1
    fi

    return 0
}

# Function to verify a domain
verify_domain() {
    local domain=$1
    local expected_leaf=$2
    local expected_issuer=$3

    echo -e "${BLUE}Domain: $domain${NC}"
    echo "----------------------------------------"

    # Get actual hashes
    echo -n "  Fetching certificates... "
    local actual_leaf=$(get_cert_hash "$domain")
    local actual_issuer=$(get_issuer_hash "$domain")
    echo "done"

    # Get certificate details
    local leaf_subject=$(get_cert_subject "$domain")
    local issuer_subject=$(get_issuer_subject "$domain")
    local leaf_expiry=$(get_cert_expiry "$domain")
    local issuer_expiry=$(get_issuer_expiry "$domain")

    # Verify leaf certificate
    echo ""
    echo "  Leaf Certificate:"
    echo "    Subject: $leaf_subject"
    echo "    Expected: $expected_leaf"
    echo "    Actual:   $actual_leaf"

    if [ "$expected_leaf" == "$actual_leaf" ]; then
        echo -e "    ${GREEN}✓ MATCH${NC}"
    else
        echo -e "    ${RED}✗ MISMATCH${NC}"
        ERRORS=$((ERRORS + 1))
    fi

    echo "    Expires:  $leaf_expiry"
    expiry_status=$(check_expiry_warning "$leaf_expiry")
    expiry_result=$?
    if [ $expiry_result -eq 2 ]; then
        echo -e "    ${RED}⚠️  CERTIFICATE EXPIRED!${NC}"
        ERRORS=$((ERRORS + 1))
    elif [ $expiry_result -eq 1 ]; then
        days=$(echo $expiry_status | cut -d':' -f2)
        echo -e "    ${YELLOW}⚠️  Expires in $days days${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi

    # Verify issuer certificate
    echo ""
    echo "  Issuer Certificate:"
    echo "    Subject: $issuer_subject"
    echo "    Expected: $expected_issuer"
    echo "    Actual:   $actual_issuer"

    if [ "$expected_issuer" == "$actual_issuer" ]; then
        echo -e "    ${GREEN}✓ MATCH${NC}"
    else
        echo -e "    ${RED}✗ MISMATCH${NC}"
        ERRORS=$((ERRORS + 1))
    fi

    echo "    Expires:  $issuer_expiry"

    echo ""
}

# Main verification
echo "Verifying pinned domains..."
echo ""

# issuer.ageverification.dev
verify_domain "issuer.ageverification.dev" \
    "kYirK0neGc3RSMFJHqxvZwVox0pg7KwThB8nOjSrsec=" \
    "LoMHBotttiDko50Gi13uXW71eIy7LAttI+rYT8wXF4w="

# test.issuer.dev.ageverification.dev
verify_domain "test.issuer.dev.ageverification.dev" \
    "fSmGMVbBf12HnesWiAAVaQEkcpelMBrxdmrJAGpk/ew=" \
    "LoMHBotttiDko50Gi13uXW71eIy7LAttI+rYT8wXF4w="

# issuer.dev.ageverification.dev
verify_domain "issuer.dev.ageverification.dev" \
    "kLSOVQB5XnJ7RxpZluD7dinfCApcGomiQMbmuTVLAbc=" \
    "kZwN96eHtZftBWrOZUsd6cA4es80n3NzSk/XtYz2EqQ="

# passport.issuer.dev.ageverification.dev
verify_domain "passport.issuer.dev.ageverification.dev" \
    "pRm//hr2npxXsIkhvYKMtyDg7dadwDgcuQOHODQvaHs=" \
    "nWN7PSep5XDQdge5zK24CnCRXHr3KvzhKEGxsdqCX9E="

# Summary
echo "========================================="
echo "Verification Summary"
echo "========================================="

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All certificates verified successfully!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Verification completed with $WARNINGS warning(s)${NC}"
    echo ""
    echo "Action required: Review expiring certificates"
    exit 0
else
    echo -e "${RED}✗ Verification FAILED with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    echo ""
    echo "CRITICAL: Certificate pinning configuration is out of date!"
    echo "Action required: Update $PINNING_CONFIG"
    exit 1
fi
