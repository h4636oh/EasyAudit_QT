#!/usr/bin/env bash

# Script to remediate difok password policy settings

echo "Remediating difok password policy..."

# 1. Update /etc/security/pwquality.conf or create a new conf file in /etc/security/pwquality.conf.d/
echo "Ensuring difok is set to 2 or more in pwquality configuration..."

# Comment out any existing difok settings in /etc/security/pwquality.conf
sed -ri 's/^\s*difok\s*=/# &/' /etc/security/pwquality.conf

# Check if the directory exists, if not, create it
if [ ! -d /etc/security/pwquality.conf.d/ ]; then
    mkdir /etc/security/pwquality.conf.d/
    echo "Created directory /etc/security/pwquality.conf.d/"
fi

# Create or modify 50-pwdifok.conf in /etc/security/pwquality.conf.d/ to set difok = 2
echo "difok = 2" > /etc/security/pwquality.conf.d/50-pwdifok.conf
echo "Set difok = 2 in /etc/security/pwquality.conf.d/50-pwdifok.conf"

# 2. Remove difok argument from any PAM files
echo "Cleaning up PAM files to remove invalid difok arguments..."

# Search for PAM files with difok and remove the difok argument
grep -Pl -- '\bpam_pwquality\.so\h+([^#\n\r]+\h+)?difok\b' /usr/share/pam-configs/* | while read -r pam_file; do
    echo "Removing difok argument from $pam_file"
    sed -ri 's/\bdifok\s*=\s*[0-9]+\b//g' "$pam_file"
done

echo "Remediation completed successfully."