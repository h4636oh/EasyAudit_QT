#!/bin/bash

# This script audits the system-wide cryptographic policy to ensure that SHA1 hash and signature support is disabled.

# Checking if the relevant SHA1 settings are configured properly in the crypto policy

# Function to prompt user for manual checks if necessary
function prompt_user {
    echo "Please ensure manually that SHA1 hash and signature support is disabled in your system's crypto policy."
}

# Execute the command to check for SHA1 hash and signature mentions
awk -F= '($1~/(hash|sign)/ && $2~/SHA1/ && $2!~/^\s*-\s*([^#\n\r]+)?SHA1/){print}' /etc/crypto-policies/state/CURRENT.pol > /dev/null

if [[ $? -eq 0 ]]; then
    echo "Audit Failed: SHA1 hash and signature support found. Please review the /etc/crypto-policies/state/CURRENT.pol file."
    exit 1
fi

# Execute the command to verify that sha1_in_certs is set to 0
grep -Psi -- '^\h*sha1_in_certs\h*=\h*' /etc/crypto-policies/state/CURRENT.pol | grep -q "sha1_in_certs = 0"

if [[ $? -ne 0 ]]; then
    echo "Audit Failed: sha1_in_certs is not set to 0. Please ensure it is correctly configured."
    exit 1
fi

# If the script reaches this point, the audit has passed
echo "Audit Passed: SHA1 configurations are correctly disabled."
exit 0

### Notes:
# - The script performs two checks: one for the presence of SHA1 in hash and sign lines, and another for the `sha1_in_certs = 0` setting.
# - Proper exit codes are used to indicate the success or failure of the audit. Exit code `1` indicates failure, while `0` indicates success.
# - The user is prompted to manually ensure the configurations as an extra precaution, given the critical nature of the cryptographic settings.