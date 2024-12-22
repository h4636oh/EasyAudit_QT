#!/usr/bin/env bash

# Check if unlock_time is correctly set in /etc/security/faillock.conf
echo "Verifying unlock_time setting in /etc/security/faillock.conf..."

# Search for unlock_time in /etc/security/faillock.conf
if grep -qP '^\h*unlock_time\h*=\h*(0|9[0-9][0-9]|[1-9][0-9]{3,})\b' /etc/security/faillock.conf; then
    echo "unlock_time is correctly set."
else
    # If unlock_time is not set to 0 or >= 900, correct it
    echo "Setting unlock_time to 900 in /etc/security/faillock.conf..."
    sed -i 's/^\h*unlock_time\h*=\h*[0-9]\+/unlock_time = 900/' /etc/security/faillock.conf
fi

# Search for pam_faillock.so with unlock_time in PAM configuration files
echo "Verifying pam_faillock.so configuration in PAM files..."

# Search for pam_faillock.so with unlock_time in pam-configs
files_with_unlock_time=$(grep -Pl -- '\bpam_faillock\.so\h+([^#\n\r]+\h+)?unlock_time\b' /usr/share/pam-configs/*)

if [[ -n "$files_with_unlock_time" ]]; then
    # Edit each file and remove unlock_time from pam_faillock.so lines
    for file in $files_with_unlock_time; do
        echo "Removing unlock_time from $file..."
        sed -i 's/\(pam_faillock.so\h+[^#]*\)\bunlock_time=[0-9]\+/\1/' "$file"
    done
else
    echo "No invalid unlock_time arguments found in PAM configuration files."
    exit 1
fi

echo "Remediation complete."
