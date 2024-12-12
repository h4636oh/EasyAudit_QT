#!/usr/bin/env bash

# Step 1: Check for pam_pwhistory.so line with use_authtok argument
echo "Checking for 'use_authtok' argument in the pam_pwhistory.so line in /etc/pam.d/common-password..."

# Run grep to search for pam_pwhistory.so with use_authtok in /etc/pam.d/common-password
if grep -qP '^\s*password\s+[^#\n\r]+\s+pam_pwhistory\.so\s+([^#\n\r]+\s+)?use_authtok\b' /etc/pam.d/common-password; then
    echo "The 'use_authtok' argument exists in the pam_pwhistory.so line in /etc/pam.d/common-password."
else
    echo "The 'use_authtok' argument is missing from the pam_pwhistory.so line in /etc/pam.d/common-password."
    exit 1
fi