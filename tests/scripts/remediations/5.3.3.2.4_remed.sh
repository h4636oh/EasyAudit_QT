#!/usr/bin/env bash

# Remediation script to set maxrepeat to 3 or less and ensure compliance

echo "Starting remediation for maxrepeat setting..."

# 1. Update or create the configuration file for maxrepeat
echo "Creating or modifying /etc/security/pwquality.conf.d/50-pwrepeat.conf..."

# Ensure the directory exists
[ ! -d /etc/security/pwquality.conf.d/ ] && mkdir -p /etc/security/pwquality.conf.d/

# Update the maxrepeat setting to 3 or less
sed -ri 's/^\s*maxrepeat\s*=/# &/' /etc/security/pwquality.conf

# Add the correct maxrepeat value if it's not already present
printf '\n%s' "maxrepeat = 3" > /etc/security/pwquality.conf.d/50-pwrepeat.conf
echo "maxrepeat set to 3 in /etc/security/pwquality.conf.d/50-pwrepeat.conf."

# 2. Check for invalid maxrepeat arguments in /usr/share/pam-configs/*
echo "Checking PAM configuration files for invalid maxrepeat arguments..."

# Search for maxrepeat in PAM configuration files
grep -Pl -- '\bpam_pwquality\.so\h+([^#\n\r]+\h+)?maxrepeat\b' /usr/share/pam-configs/*

if [ $? -eq 0 ]; then
    echo "Invalid maxrepeat arguments found in PAM config files. Removing..."

    # Loop through the files that contain invalid maxrepeat arguments
    grep -Pl -- '\bpam_pwquality\.so\h+([^#\n\r]+\h+)?maxrepeat\b' /usr/share/pam-configs/* | while read -r file; do
        # Remove the maxrepeat argument from each file
        sed -i '/pam_pwquality\.so/ s/\s*maxrepeat=[^ ]*//g' "$file"
        echo "Removed maxrepeat argument from $file."
    done
else
    echo "No invalid maxrepeat arguments found in PAM config files."
fi

echo "Remediation for maxrepeat completed successfully."