#!/usr/bin/env bash

# Script to audit and remediate the maxrepeat password option

echo "Starting audit and remediation of maxrepeat password setting..."

# 1. Check if maxrepeat is set to 3 or less and not 0
echo "Auditing maxrepeat in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/..."

# Search for maxrepeat settings in the specified files and check that the value is between 1 and 3 (inclusive)
grep -Psi '^\h*maxrepeat\h*=\h*[1-3]\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf
if [ $? -eq 0 ]; then
    echo "Valid maxrepeat setting found."
else
    echo "Invalid or missing maxrepeat setting. Remediating..."
    
    # 2. Create or modify the file with maxrepeat set to 3 or less
    config_file="/etc/security/pwquality.conf.d/50-pwrepeat.conf"
    
    # Ensure the directory exists
    [ ! -d /etc/security/pwquality.conf.d/ ] && mkdir -p /etc/security/pwquality.conf.d/
    
    # Create or modify the file to set maxrepeat to 3
    cat <<EOF > "$config_file"
# Password repetition settings
maxrepeat = 3
EOF
    echo "maxrepeat set to 3 in $config_file."
fi

# 3. Check for maxrepeat argument in pam_pwquality.so in /etc/pam.d/common-password
echo "Auditing pam_pwquality.so settings in /etc/pam.d/common-password..."

grep -Psi '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?maxrepeat\h*=\h*(0|[4-9]|[1-9][0-9]+)\b' /etc/pam.d/common-password
if [ $? -eq 0 ]; then
    echo "Invalid maxrepeat setting found in /etc/pam.d/common-password. Removing..."
    
    # Remove invalid maxrepeat argument from the line in /etc/pam.d/common-password
    sed -i '/pam_pwquality\.so/ s/\s*maxrepeat=[^ ]*//g' /etc/pam.d/common-password
    echo "Removed invalid maxrepeat setting from /etc/pam.d/common-password."
    exit 1
else
    echo "No invalid maxrepeat setting found in /etc/pam.d/common-password."
fi

echo "Audit and remediation of maxrepeat completed successfully."