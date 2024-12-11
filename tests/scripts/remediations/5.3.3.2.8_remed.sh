#!/usr/bin/env bash

# Remediation script to add enforce_for_root to the pwquality configuration files

echo "Starting remediation for enforce_for_root..."

# Check if the directory exists, if not, create it
if [ ! -d /etc/security/pwquality.conf.d/ ]; then
    echo "Directory /etc/security/pwquality.conf.d/ does not exist. Creating it..."
    mkdir -p /etc/security/pwquality.conf.d/
fi

# Create or modify the 50-pwroot.conf file to enforce enforce_for_root
echo "Adding enforce_for_root to /etc/security/pwquality.conf.d/50-pwroot.conf"
printf '\n%s\n' "enforce_for_root" > /etc/security/pwquality.conf.d/50-pwroot.conf

# Optionally, you could also ensure that enforce_for_root is added to /etc/security/pwquality.conf if needed
if ! grep -q 'enforce_for_root' /etc/security/pwquality.conf; then
    echo "enforce_for_root not found in /etc/security/pwquality.conf. Adding it..."
    echo "enforce_for_root" >> /etc/security/pwquality.conf
fi

echo "Remediation completed. enforce_for_root has been added."