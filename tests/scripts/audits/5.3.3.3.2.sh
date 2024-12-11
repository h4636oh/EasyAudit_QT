#!/usr/bin/env bash

# Script to audit if enforce_for_root is set on pam_pwhistory.so line

echo "Starting audit for enforce_for_root argument..."

# Search for the enforce_for_root argument in the pam_pwhistory.so line in /etc/pam.d/common-password
if grep -Psi '^\h*password\h+[^#\n\r]+\h+pam_pwhistory\.so\h+([^#\n\r]+\h+)?enforce_for_root\b' /etc/pam.d/common-password > /dev/null; then
    echo "enforce_for_root is correctly set in /etc/pam.d/common-password"
else
    echo "enforce_for_root is NOT set in /etc/pam.d/common-password. Remediation needed."
fi