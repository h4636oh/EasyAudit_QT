#!/usr/bin/env bash

# Remediation script to comment out or remove dictcheck = 0 and dictcheck argument.

echo "Starting remediation for dictcheck setting..."

# 1. Comment out or remove dictcheck = 0 in pwquality configuration files
echo "Commenting out or removing dictcheck = 0 in pwquality configuration files..."

# Comment out any dictcheck = 0 in /etc/security/pwquality.conf and .conf files
sed -ri 's/^\s*dictcheck\s*=\s*0/# &/' /etc/security/pwquality.conf
[ ! -d /etc/security/pwquality.conf.d/ ] && mkdir /etc/security/pwquality.conf.d/
sed -ri 's/^\s*dictcheck\s*=\s*0/# &/' /etc/security/pwquality.conf.d/*.conf

echo "Finished commenting out dictcheck = 0 in pwquality configuration files."

# 2. Remove dictcheck argument from pam_pwquality.so lines in pam-configs
echo "Checking pam-configs for dictcheck argument..."

# Search for pam_pwquality.so with dictcheck in /usr/share/pam-configs and remove dictcheck argument
grep -Pl -- '\bpam_pwquality\.so\h+([^#\n\r]+\h+)?dictcheck\b' /usr/share/pam-configs/* | while read -r file; do
    echo "Editing $file to remove dictcheck argument..."
    sed -i '/pam_pwquality\.so/ s/\s*dictcheck=[^ ]*//g' "$file"
    echo "Removed dictcheck argument from $file."
done

echo "Remediation completed. dictcheck is now correctly configured."