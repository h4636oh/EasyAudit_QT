#!/bin/bash

# Audit Script to Ensure System-Wide Crypto Policy Disables MACs Less Than 128 Bits
# This script checks whether weak MACs (less than 128 bits) are disabled in the system-wide crypto policy.
# It does NOT remediate any issues found.

# Define the filename of the current crypto policy state
CRYPTO_STATE_FILE="/etc/crypto-policies/state/CURRENT.pol"

# Description of the audit step
echo "Checking if weak MACs (less than 128 bits) are disabled in the current crypto policy..."

# Check for weak MACs in the current crypto policy file
# The grep command searches for any configuration lines in the CURRENT.pol file that enables weak MACs
WEAK_MACS_FOUND=$(grep -Pi -- '^\h*mac\h*=\h*([^#\n\r]+)?-64\b' "$CRYPTO_STATE_FILE")

# Evaluate the result of the grep command
if [ -n "$WEAK_MACS_FOUND" ]; then
    # If any weak MACs are found, print message and exit with status 1
    echo "Weak MACs are enabled. The system-wide crypto policy does not meet the required standard."
    echo "Please ensure that MACs of less than 128 bits are disabled in your crypto policy configuration."
    exit 1
else
    # If no weak MACs are found, print success message and exit with status 0
    echo "No weak MACs are enabled. The system-wide crypto policy meets the required standard."
    exit 0
fi
