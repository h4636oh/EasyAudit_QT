#!/usr/bin/env bash

# Remediation: Ensure unlock_time is set to conform to site policy

# 1. Update /etc/security/faillock.conf to ensure unlock_time is set to 900 or 0
echo "Checking and setting unlock_time in /etc/security/faillock.conf..."

# Check if unlock_time is correctly set to 0 or 900 or more
if grep -qP '^\h*unlock_time\h*=\h*(0|9[0-9][0-9]|[1-9][0-9]{3,})\b' /etc/security/faillock.conf; then
    echo "unlock_time is correctly configured."
else
    # If unlock_time is not set correctly, update it to 900
    echo "Setting unlock_time to 900 in /etc/security/faillock.conf..."
    echo "unlock_time = 900" >> /etc/security/faillock.conf
fi

# 2. Search for pam_faillock.so lines with unlock_time argument in PAM configuration files
echo "Searching for pam_faillock.so in PAM config files..."

# Find any files where pam_faillock.so has unlock_time set
files_with_unlock_time=$(grep -Pl -- '\bpam_faillock\.so\h+([^#\n\r]+\h+)?unlock_time\b' /usr/share/pam-configs/*)

if [[ -n "$files_with_unlock_time" ]]; then
    # Edit each returned file and remove unlock_time argument
    for file in $files_with_unlock_time; do
        echo "Removing unlock_time from $file..."
        sed -i 's/\(pam_faillock.so\h+[^#]*\)\bunlock_time=[0-9]\+/\1/' "$file"
    done
else
    echo "No invalid unlock_time arguments found in PAM configuration files."
fi

# 3. Final output
echo "Remediation completed."