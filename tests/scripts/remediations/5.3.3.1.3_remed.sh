#!/usr/bin/env bash

# Remediation: Update /etc/security/faillock.conf and PAM files

# 1. Edit /etc/security/faillock.conf to remove or update root_unlock_time and set even_deny_root if needed
echo "Remediating /etc/security/faillock.conf..."

# Backup the file before making changes
cp /etc/security/faillock.conf /etc/security/faillock.conf.bak

# Remove or update root_unlock_time if it is set to a value less than 60 or more
sed -i '/^\s*root_unlock_time\h*=\h*[1-9]\b/d' /etc/security/faillock.conf

# Ensure root_unlock_time is set to a compliant value or is absent
if ! grep -q 'root_unlock_time' /etc/security/faillock.conf; then
    echo "root_unlock_time is not set. Setting it to 60 seconds."
    echo "root_unlock_time = 60" >> /etc/security/faillock.conf
else
    echo "root_unlock_time is set appropriately or updated."
fi

# Ensure even_deny_root is set
if ! grep -q 'even_deny_root' /etc/security/faillock.conf; then
    echo "even_deny_root is not set. Adding it."
    echo "even_deny_root" >> /etc/security/faillock.conf
else
    echo "even_deny_root is already set."
fi

# 2. Remove even_deny_root and root_unlock_time from any PAM files in /usr/share/pam-configs/
echo "Checking and updating PAM configuration files..."

grep -Pl -- '\bpam_faillock\.so\h+([^#\n\r]+\h+)?(even_deny_root|root_unlock_time)' /usr/share/pam-configs/* | while read file; do
    echo "Removing even_deny_root and root_unlock_time from $file..."
    sed -i '/even_deny_root/d' "$file"
    sed -i '/root_unlock_time/d' "$file"
done

# Final message
echo "Remediation completed. Please review the changes made in /etc/security/faillock.conf and PAM configuration files."