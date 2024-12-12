#!/usr/bin/env bash

# Script to audit the difok configuration for password quality policy

echo "Auditing difok configuration..."

# 1. Check if difok is correctly configured in /etc/security/pwquality.conf and other conf files
echo "Checking difok configuration in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/..."

# Search for the difok setting in the configuration files
difok_files=$(grep -Psi '^\h*difok\h*=\h*([2-9]|[1-9][0-9]+)\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)

if [[ -n "$difok_files" ]]; then
    echo "Found difok setting in configuration files: "
    echo "$difok_files"
else
    echo "No difok settings found with valid values (2 or more) in /etc/security/pwquality.conf or /etc/security/pwquality.conf.d/"
fi

# 2. Check for difok settings in the PAM configuration files
echo "Checking difok setting in PAM files..."

# Search for pam_pwquality with difok set to a value less than 2
invalid_difok=$(grep -Psi '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?difok\h*=\h*([0-1])\b' /etc/pam.d/common-password)

if [[ -n "$invalid_difok" ]]; then
    echo "Invalid difok configuration found in /etc/pam.d/common-password:"
    echo "$invalid_difok"
    exit 1
else
    echo "No invalid difok settings found in /etc/pam.d/common-password."
fi

# Final message
echo "Audit completed. Please ensure difok is set to 2 or more as per your site policy."