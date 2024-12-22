#!/usr/bin/env bash

# Check /etc/security/faillock.conf for deny value between 1 and 5
echo "Checking deny value in /etc/security/faillock.conf..."

# Verify that deny is set to a value between 1 and 5 (inclusive)
deny_value=$(grep -Pi '^\h*deny\h*=\h*[1-5]\b' /etc/security/faillock.conf)

if [[ -n "$deny_value" ]]; then
    echo "Fail: deny is set to 5 or less as per policy: $deny_value"
else
    echo "Pass: deny value in /etc/security/faillock.conf is not set to 5 or less"
fi

# Check /etc/pam.d/common-auth for pam_faillock settings
echo "Checking pam_faillock configuration in /etc/pam.d/common-auth..."

# Verify that deny is not set to 6 or higher for pam_faillock
deny_value_pam=$(grep -Pi '^\h*auth\h+(requisite|required|sufficient)\h+pam_faillock\.so\h+([^#\n\r]+\h+)?deny\h*=\h*(0|[6-9]|[1-9][0-9]+)\b' /etc/pam.d/common-auth)

if [[ -n "$deny_value_pam" ]]; then
    echo "Fail: deny value is greater than 5 in /etc/pam.d/common-auth: $deny_value_pam"
    exit 1
else
    echo "Pass: deny value in /etc/pam.d/common-auth is within expected limits"
fi
