#!/usr/bin/env bash

# Set deny value to 5 or less in /etc/security/faillock.conf
echo "Setting deny value to 5 in /etc/security/faillock.conf..."

# Check if the deny value exists and is set to a valid value, if not, set it
if grep -qP '^\h*deny\h*=\h*[0-9]+' /etc/security/faillock.conf; then
    # If deny is already set, update it to 5 if it's not already set to 5
    sed -i 's/^\h*deny\h*=\h*[0-9]\+/deny = 5/' /etc/security/faillock.conf
else
    # If deny is not set, add the deny = 5 line
    echo "deny = 5" >> /etc/security/faillock.conf
fi

# Search for pam_faillock.so with deny argument in PAM configuration files
echo "Removing deny argument from pam_faillock.so in PAM configuration files..."

# Search for pam_faillock.so with a deny argument in pam-configs
files_with_deny=$(grep -Pl -- '\bpam_faillock\.so\h+([^#\n\r]+\h+)?deny\b' /usr/share/pam-configs/*)

if [[ -n "$files_with_deny" ]]; then
    # Edit each file and remove deny=<N> arguments from pam_faillock.so lines
    for file in $files_with_deny; do
        echo "Removing deny from $file..."
        sed -i 's/\(pam_faillock.so\h+[^#]*\)\bdeny=[0-9]\+/\1/' "$file"
    done
else
    echo "No deny arguments found in PAM configuration files."
fi

echo "Remediation complete."