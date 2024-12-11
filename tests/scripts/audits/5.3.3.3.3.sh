#!/usr/bin/env bash

# Step 1: Check for pam_pwhistory.so line with use_authtok argument

# Determine the correct PAM file based on the system
pam_file="/etc/pam.d/common-password"
if [ ! -f "$pam_file" ]; then
    pam_file="/etc/pam.d/system-auth"
    if [ ! -f "$pam_file" ]; then
        echo "Error: Neither /etc/pam.d/common-password nor /etc/pam.d/system-auth was found on this system."
        exit 2
    fi
fi

echo "Checking for 'use_authtok' argument in the pam_pwhistory.so line in $pam_file..."

# Run grep to search for pam_pwhistory.so with use_authtok in the identified PAM file
if grep -qP '^\s*password\s+[^#\n\r]+\s+pam_pwhistory\.so\s+([^#\n\r]+\s+)?use_authtok\b' "$pam_file"; then
    echo "The 'use_authtok' argument exists in the pam_pwhistory.so line in $pam_file."
else
    echo "The 'use_authtok' argument is missing from the pam_pwhistory.so line in $pam_file."
    exit 1
fi
