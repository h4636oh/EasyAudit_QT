#!/bin/bash

# Script to audit system-wide crypto policy to ensure EtM is disabled for SSH.
# This is only an audit script and does not perform any remediation.
# Assumptions: The system uses the crypto policy directory as mentioned in the input text.

# Define the path to the current policy file
CRYPTO_POLICY_FILE="/etc/crypto-policies/state/CURRENT.pol"

# Check if the CVE issue is addressed or EtM is disabled
grep_output=$(grep -Psi -- '^\h*etm\b' "$CRYPTO_POLICY_FILE")

# Define the required output conditions
required_output=(
    "etm@libssh = DISABLE_ETM"
    "etm@openssh-client = DISABLE_ETM"
    "etm@openssh-server = DISABLE_ETM"
    "etm = DISABLE_ETM"
)

# Audit: Checking if EtM for SSH is disabled according to the policy
check_etm_disabled() {
    for pattern in "${required_output[@]}"; do
        if echo "$grep_output" | grep -q "$pattern"; then
            return 0
        fi
    done
    return 1
}

# Perform the audit check
if check_etm_disabled; then
    echo "SUCCESS: EtM is disabled for SSH in system-wide crypto policy."
    exit 0
else
    echo "FAILURE: EtM is NOT disabled for SSH in system-wide crypto policy."
    exit 1
fi

# This Bash script strictly performs an audit based on the requirements provided. If the audit passes, it exits with a status of 0 (success), and if it fails, it exits with a status of 1 (failure). The script checks if the current crypto policy disables Encrypt-then-MAC (EtM) for SSH according to the conditions specified in the input.