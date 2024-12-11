#!/usr/bin/env bash

# Define the file to check for use_authtok in the pam_unix.so lines
PAM_FILES=(
    "/etc/pam.d/common-password"
    "/etc/pam.d/common-auth"
    "/etc/pam.d/common-account"
    "/etc/pam.d/common-session"
    "/etc/pam.d/common-session-noninteractive"
)

echo "Starting audit for use_authtok argument in pam_unix.so..."

# Iterate over each file in PAM_FILES and check if use_authtok is set
for file in "${PAM_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "Checking file: $file"

        # Check for pam_unix.so lines with use_authtok
        if grep -qP "^\s*password\s+[^#\n\r]*pam_unix\.so\s+[^#\n\r]*\buse_authtok\b" "$file"; then
            echo "Verified: 'use_authtok' is set in pam_unix.so line in $file"
        else
            echo "Warning: 'use_authtok' is NOT set in pam_unix.so line in $file"
        fi
    else
        echo "Error: File $file not found!"
    fi
done

echo "Audit completed."