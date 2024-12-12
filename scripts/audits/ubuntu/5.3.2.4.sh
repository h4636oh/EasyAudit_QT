#!/usr/bin/env bash

# Search for pam_pwhistory in /etc/pam.d/common-password
echo "Checking for pam_pwhistory configuration in /etc/pam.d/common-password..."
grep -P -- '\bpam_pwhistory\.so\b' /etc/pam.d/common-password

# Check if the configuration exists and matches the expected output
if [[ $? -eq 0 ]]; then
    echo "pam_pwhistory is enabled."
    echo "Verifying the configuration..."
    # Check if the configuration matches the expected format (remember=24 enforce_for_root)
    grep -P -- '\bpam_pwhistory\.so\b' /etc/pam.d/common-password | grep -P 'remember=24 enforce_for_root'
    if [[ $? -eq 0 ]]; then
        echo "Configuration matches expected settings: remember=24 enforce_for_root."
    else
        echo "pam_pwhistory exists but configuration doesn't match expected settings."
    fi
else
    echo "pam_pwhistory is not enabled in /etc/pam.d/common-password."
    exit 1
fi