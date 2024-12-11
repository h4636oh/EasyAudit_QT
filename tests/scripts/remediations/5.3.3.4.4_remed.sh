#!/usr/bin/env bash

# Check if required files exist and process them
PAM_CONFIGS_DIR="/usr/share/pam-configs"
PAM_FILES=$(awk '/Password-Type:/{ f = 1;next } /-Type:/{ f = 0 } f {if (/pam_unix\.so/) print FILENAME}' "$PAM_CONFIGS_DIR"/*)

# Check if pam-auth-update is available
if ! command -v pam-auth-update &>/dev/null; then
    echo "Error: pam-auth-update command not found!"
    exit 1
fi

# Process each file that uses pam_unix.so
for file in $PAM_FILES; do
    echo "Processing file: $file"

    # Check if the file has a Password section and edit it
    if grep -q "^Password:" "$file"; then
        # Ensure the 'use_authtok' is added to the pam_unix.so line under the Password section
        sed -i '/^Password:/,/^Password-Initial:/s/pam_unix\.so\s\+/\0use_authtok /' "$file"

        # If the Password-Initial section exists, do not add 'use_authtok' there
        if grep -q "^Password-Initial:" "$file"; then
            echo "Skipping use_authtok in Password-Initial section in $file"
        else
            # Ensure 'use_authtok' is not added to the Password-Initial section
            echo "use_authtok added in Password section of $file"
        fi
    else
        echo "No Password section found in $file, skipping."
    fi
done

# Update the PAM configuration with the new settings
for file in $PAM_FILES; do
    MODIFIED_PROFILE_NAME=$(basename "$file")
    echo "Running pam-auth-update for: $MODIFIED_PROFILE_NAME"
    sudo pam-auth-update --enable "$MODIFIED_PROFILE_NAME"
done

echo "Remediation completed."