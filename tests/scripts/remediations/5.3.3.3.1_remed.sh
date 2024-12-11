#!/usr/bin/env bash

# Script to remediate pwhistory remember option in PAM configuration files

echo "Starting remediation for pwhistory remember option..."

# Search for files with pam_pwhistory.so in the Password section and output their filenames
files_to_modify=$(awk '/Password-Type:/{ f = 1;next } /-Type:/{ f = 0 } f {if (/pam_pwhistory\.so/) print FILENAME}' /usr/share/pam-configs/*)

# Check if any files were found
if [ -z "$files_to_modify" ]; then
    echo "No files found that require modification."
else
    echo "Files to modify:"
    echo "$files_to_modify"

    # Loop through the files and add or modify the remember=24 option in the Password section
    for file in $files_to_modify; do
        echo "Modifying $file..."

        # Check if pam_pwhistory line exists and modify it
        if grep -q 'pam_pwhistory.so' "$file"; then
            # Ensure the remember=24 is set
            sed -ri '/Password:/,/^$/{/pam_pwhistory\.so/ {s/remember=[^ ]*/remember=24/}}' "$file"
            echo "Modified pam_pwhistory.so line to include remember=24 in $file"
        else
            # If pam_pwhistory.so isn't found, add the line
            sed -ri '/Password:/a\    requisite pam_pwhistory.so remember=24 enforce_for_root try_first_pass use_authtok' "$file"
            echo "Added pam_pwhistory.so line with remember=24 to $file"
        fi
    done
fi

# Run pam-auth-update to apply the changes
echo "Updating PAM configuration with pam-auth-update..."
pam-auth-update --enable pwhistory

echo "Remediation completed."