#!/usr/bin/env bash

# Check for pam_pwhistory.so line in /usr/share/pam-configs/* that does not include 'use_authtok'
echo "Checking for 'use_authtok' argument in pam_pwhistory.so line in /usr/share/pam-configs/..."

# List files with pam_pwhistory.so and missing 'use_authtok'
awk '/Password-Type:/{ f = 1;next } /-Type:/{ f = 0 } f {if (/pam_pwhistory\.so/ && !/use_authtok/) print FILENAME}' /usr/share/pam-configs/* | while read -r file; do
    echo "Modifying $file to include 'use_authtok' argument."

    # Add 'use_authtok' to the pam_pwhistory.so line
    sed -ri '/pam_pwhistory\.so/ s/$/ use_authtok/' "$file"
    
    # Enable the modified profile using pam-auth-update
    profile_name=$(basename "$file" .conf)
    pam-auth-update --enable "$profile_name"
    
    echo "'use_authtok' added and profile updated: $profile_name"
done

# Check if pam_pwhistory.so line in /etc/pam.d/common-password includes 'use_authtok'
echo "Checking /etc/pam.d/common-password..."

if ! grep -qP '^\s*password\s+[^#\n\r]+\s+pam_pwhistory\.so\s+([^#\n\r]+\s+)?use_authtok\b' /etc/pam.d/common-password; then
    echo "'use_authtok' missing in /etc/pam.d/common-password. Adding it now."

    # Add 'use_authtok' argument to pam_pwhistory.so line in /etc/pam.d/common-password
    sed -ri '/pam_pwhistory\.so/ s/$/ use_authtok/' /etc/pam.d/common-password
    
    echo "'use_authtok' added to /etc/pam.d/common-password"
fi

echo "Remediation complete."