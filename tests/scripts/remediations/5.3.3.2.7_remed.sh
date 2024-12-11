#!/usr/bin/env bash

# Remediation script to remove enforcing=0 setting from pwquality configuration files and PAM files.

echo "Starting remediation for enforcing=0 setting..."

# 1. Remove enforcing=0 from PAM configuration files
echo "Checking for enforcing=0 in /usr/share/pam-configs/* files..."

# Search for enforcing=0 in PAM configuration files under /usr/share/pam-configs/
grep -Pl -- '\bpam_pwquality\.so\h+([^#\n\r]+\h+)?enforcing=0\b' /usr/share/pam-configs/*

# If enforcing=0 is found, remove it from the pam_pwquality.so line
grep -Pl -- '\bpam_pwquality\.so\h+([^#\n\r]+\h+)?enforcing=0\b' /usr/share/pam-configs/* | while read -r file; do
    echo "Editing $file to remove enforcing=0 argument..."
    sed -i '/pam_pwquality\.so/ s/\s*enforcing=0//g' "$file"
    echo "Removed enforcing=0 argument from $file."
done

echo "Finished removing enforcing=0 from PAM configuration files."

# 2. Remove enforcing=0 from pwquality configuration files
echo "Checking for enforcing=0 in pwquality configuration files..."

# Search for enforcing=0 in /etc/security/pwquality.conf and .conf files under /etc/security/pwquality.conf.d/
grep -PHsi '^\h*enforcing\h*=\h*0\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf

# If enforcing=0 is found, comment it out in the configuration files
sed -ri 's/^\s*enforcing\s*=\s*0/# &/' /etc/security/pwquality.conf
[ ! -d /etc/security/pwquality.conf.d/ ] && mkdir /etc/security/pwquality.conf.d/
sed -ri 's/^\s*enforcing\s*=\s*0/# &/' /etc/security/pwquality.conf.d/*.conf

echo "Finished removing enforcing=0 from pwquality configuration files."

echo "Remediation completed. enforcing=0 has been removed from configuration files."