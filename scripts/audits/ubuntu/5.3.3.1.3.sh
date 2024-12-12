#!/usr/bin/env bash

# Audit: Verify root_unlock_time is set correctly in faillock.conf and pam_faillock.so module

# 1. Check if even_deny_root and/or root_unlock_time is present in /etc/security/faillock.conf
echo "Checking for even_deny_root or root_unlock_time in /etc/security/faillock.conf..."

if grep -qPi '^\h*(even_deny_root|root_unlock_time\h*=\h*\d+)\b' /etc/security/faillock.conf; then
    echo "Found even_deny_root or root_unlock_time in /etc/security/faillock.conf."
else
    echo "Neither even_deny_root nor root_unlock_time is set in /etc/security/faillock.conf."
    exit 1
fi

# 2. Check if root_unlock_time is set to 60 or more in /etc/security/faillock.conf
echo "Checking if root_unlock_time is set to 60 or more in /etc/security/faillock.conf..."

if grep -qPi '^\h*root_unlock_time\h*=\h*([1-9]|[1-5][0-9])\b' /etc/security/faillock.conf; then
    echo "root_unlock_time is set to a value less than 60, which is non-compliant."
else
    echo "root_unlock_time is either not set or is set to 60 or more (compliant)."
fi

# 3. Check if root_unlock_time is set in the pam_faillock.so module in PAM configuration
echo "Checking if root_unlock_time is set in pam_faillock.so module in PAM configuration..."

if grep -qPi '^\h*auth\h+([^#\n\r]+\h+)pam_faillock\.so\h+([^#\n\r]+\h+)?root_unlock_time\h*=\h*([1-9]|[1-5][0-9])\b' /etc/pam.d/common-auth; then
    echo "root_unlock_time is set to a value less than 60 in pam_faillock.so, which is non-compliant."
else
    echo "root_unlock_time is either not set or is set to 60 or more in pam_faillock.so (compliant)."
    exit 1
fi

# Final message
echo "Audit completed."