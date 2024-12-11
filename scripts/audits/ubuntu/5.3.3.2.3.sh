#!/usr/bin/env bash

# Script to audit password complexity settings

echo "Auditing password complexity settings..."

# 1. Check for minclass, dcredit, ucredit, lcredit, ocredit in pwquality.conf and pwquality.conf.d
echo "Checking for minclass, dcredit, ucredit, lcredit, ocredit settings in pwquality configuration files..."

# Search for minclass, dcredit, ucredit, lcredit, ocredit in /etc/security/pwquality.conf and pwquality.conf.d/
grep -Psi '^\h*(minclass|[dulo]credit)\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf

# 2. Check for overriding of pwquality arguments in /etc/pam.d/common-password
echo "Checking for overridden arguments in /etc/pam.d/common-password..."

grep -Psi '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?(minclass=\d*|[dulo]credit=-?\d*)\b' /etc/pam.d/common-password

echo "Audit completed."