#!/usr/bin/env bash

# This script audits whether a bootloader password has been set for GRUB 2.
# The audit is applicable to both Level 1 - Server and Level 1 - Workstation as per the profile applicability.

# Function to check if the GRUB 2 password is set
audit_grub_password() {
    local grub_password_file
    grub_password_file="$(find /boot -type f -name 'user.cfg' ! -empty 2>/dev/null)"
    
    if [[ -z "$grub_password_file" ]]; then
        echo "Bootloader password file not found or is empty. Bootloader password is not set."
        exit 1
    fi

    # Check if the password line exists in the user.cfg file
    local password_check
    password_check=$(awk '/^GRUB2_PASSWORD=/' "$grub_password_file")

    if [[ -n "$password_check" ]]; then
        echo "Bootloader password is set: $password_check"
        exit 0
    else
        echo "Bootloader password is not set correctly."
        exit 1
    fi
}

# Run the audit function
audit_grub_password

