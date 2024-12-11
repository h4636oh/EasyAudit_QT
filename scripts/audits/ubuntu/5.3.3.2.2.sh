#!/usr/bin/env bash

# Script to audit password length policy (minlen >= 14)

echo "Auditing password length policy (minlen >= 14)..."

# 1. Verify that the minlen value is 14 or more in pwquality.conf files
echo "Checking minlen setting in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/..."

grep -Psi '^\h*minlen\h*=\h*(1[4-9]|[2-9][0-9]|[1-9][0-9]{2,})\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf

# 2. Verify that minlen is not set to less than 14 in PAM configuration files
echo "Checking PAM configurations for minlen setting..."

grep -Psi '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?minlen\h*=\h*([0-9]|1[0-3])\b' /etc/pam.d/system-auth /etc/pam.d/common-password

echo "Audit completed."