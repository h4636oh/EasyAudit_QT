#!/usr/bin/env bash

# Check if pam_pwquality is enabled in /etc/pam.d/common-password
echo "Checking for pam_pwquality in /etc/pam.d/common-password..."
grep -P -- '\bpam_pwquality\.so\b' /etc/pam.d/common-password

# Check for the expected configuration (retry=3)
echo "Checking if pam_pwquality is configured correctly..."
grep -P -- 'password requisite pam_pwquality.so retry=3' /etc/pam.d/common-password

if [[ $? -eq 0 ]]; then
    echo "pam_pwquality is correctly configured."
else
    echo "pam_pwquality is not correctly configured or not found."
    exit 1
fi
