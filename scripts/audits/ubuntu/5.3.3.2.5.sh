#!/usr/bin/env bash

# Remediation script to set maxsequence to 3 or less and ensure compliance

echo "Starting remediation for maxsequence setting..."

# 1. Update or create the configuration file for maxsequence
echo "Creating or modifying /etc/security/pwquality.conf.d/50-pwmaxsequence.conf..."

# Ensure the directory exists
[ ! -d /etc/security/pwquality.conf.d/ ] && mkdir -p /etc/security/pwquality.conf.d/

# Update the maxsequence setting to 3 or less
sed -ri 's/^\s*maxsequence\s*=/# &/' /etc/security/pwquality.conf

# Add the correct maxsequence value if it's not already present
printf '\n%s' "maxsequence = 3" > /etc/security/pwquality.conf.d/50-pwmaxsequence.conf
echo "maxsequence set to 3 in /etc/security/pwquality.conf.d/50-pwmaxsequence.conf."

# 2. Check for invalid maxsequence arguments in /usr/share/pam-configs/*
echo "Checking PAM configuration files for invalid maxsequence arguments..."

# Search for maxsequence in PAM configuration files
grep -Pl -- '\bpam_pwquality\.so\h+([^#\n\r]+\h+)?maxsequence\b' /usr/share/pam-configs/*

if [ $? -eq 0 ]; then
    echo "Invalid maxsequence arguments found in PAM config files. Removing..."

    # Loop through the files that contain invalid maxsequence arguments
    grep -Pl -- '\bpam_pwquality\.so\h+([^#\n\r]+\h+)?maxsequence\b' /usr/share/pam-configs/* | while read -r file; do
        # Remove the maxsequence argument from each file
        sed -i '/pam_pwquality\.so/ s/\s*maxsequence=[^ ]*//g' "$file"
        echo "Removed maxsequence argument from $file."
    done
else
    echo "No invalid maxsequence arguments found in PAM config files."
fi

echo "Remediation for maxsequence completed successfully."