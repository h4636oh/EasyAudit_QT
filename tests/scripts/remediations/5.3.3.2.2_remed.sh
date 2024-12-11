#!/usr/bin/env bash

# Script to remediate password length policy (minlen >= 14)

echo "Remediating password length policy (minlen >= 14)..."

# 1. Edit or create the pwquality.conf file to set minlen to 14 or more
echo "Setting minlen = 14 in /etc/security/pwquality.conf.d/50-pwlength.conf..."

# Make sure /etc/security/pwquality.conf is commented out if it has minlen
sed -ri 's/^\s*minlen\s*=/# &/' /etc/security/pwquality.conf

# Ensure the directory exists
[ ! -d /etc/security/pwquality.conf.d/ ] && mkdir -p /etc/security/pwquality.conf.d/

# Create or modify the 50-pwlength.conf file to set minlen to 14
printf '\n%s' "minlen = 14" > /etc/security/pwquality.conf.d/50-pwlength.conf

# 2. Check for and remove any conflicting minlen argument in PAM config files
echo "Removing any minlen argument from PAM configuration files..."

# Search for PAM configuration files that have minlen and remove it
grep -Pl '\bpam_pwquality\.so\h+([^#\n\r]+\h+)?minlen\b' /usr/share/pam-configs/* | while read -r file; do
    sed -i '/pam_pwquality.so/s/\(minlen=[^ ]*\)//g' "$file"
done

# 3. Update PAM configuration
echo "PAM configuration files have been updated."

echo "Remediation completed."