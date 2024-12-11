#!/usr/bin/env bash

# Remediation script to verify and correct the dictcheck setting.

echo "Starting audit for dictcheck setting..."

# 1. Audit pwquality.conf and .conf files for dictcheck = 0
echo "Checking pwquality configuration files for dictcheck = 0..."

grep -Psi '^\h*dictcheck\h*=\h*0\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf

if [ $? -eq 0 ]; then
    echo "dictcheck = 0 found in configuration files. Remediating..."

    # Loop through and fix the files with dictcheck = 0
    grep -Pl '^\h*dictcheck\h*=\h*0\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf | while read -r file; do
        # Remove or comment out the dictcheck = 0 line
        sed -ri 's/^\s*dictcheck\s*=\s*0/# &/' "$file"
        echo "Fixed dictcheck = 0 in $file."
    done
else
    echo "No dictcheck = 0 found in pwquality configuration files."
fi

# 2. Audit PAM common-password files for dictcheck = 0
echo "Checking PAM configuration files for dictcheck = 0..."

grep -Psi '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?dictcheck\h*=\h*0\b' /etc/pam.d/common-password

if [ $? -eq 0 ]; then
    echo "dictcheck = 0 found in PAM common-password file. Remediating..."

    # Remove dictcheck argument from PAM files
    sed -i '/pam_pwquality\.so/ s/\s*dictcheck=[^ ]*//g' /etc/pam.d/common-password
    echo "Removed dictcheck = 0 from /etc/pam.d/common-password."
else
    echo "No dictcheck = 0 found in PAM configuration files."
fi

echo "Audit and remediation for dictcheck completed successfully."