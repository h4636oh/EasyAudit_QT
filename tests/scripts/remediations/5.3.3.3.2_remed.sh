#!/usr/bin/env bash

# Step 1: Check for pam_pwhistory.so entries in PAM config files
echo "Checking for pam_pwhistory.so entries in /usr/share/pam-configs/..."

# Use awk to check for pam_pwhistory.so in the Password section
awk '/Password-Type:/{ f = 1; next } /-Type:/{ f = 0 } f { if (/pam_pwhistory\.so/) print FILENAME }' /usr/share/pam-configs/*

# Step 2: Edit the files to add enforce_for_root to pam_pwhistory.so
# For each file found in step 1, add 'enforce_for_root' to the pam_pwhistory.so line if it's not present
for file in $(awk '/Password-Type:/{ f = 1; next } /-Type:/{ f = 0 } f { if (/pam_pwhistory\.so/) print FILENAME }' /usr/share/pam-configs/*); do
    echo "Editing $file to ensure enforce_for_root is set in pam_pwhistory.so"
    # Check if the line already contains enforce_for_root
    if ! grep -q 'enforce_for_root' "$file"; then
        # Add enforce_for_root to the pam_pwhistory.so line
        sed -i '/pam_pwhistory\.so/s/$/ enforce_for_root/' "$file"
    fi
done

# Step 3: Run pam-auth-update to apply the changes
echo "Running pam-auth-update to enable the modified profile(s)..."
# Assuming the modified profile name is 'pwhistory', replace with the correct profile name if necessary
sudo pam-auth-update --enable pwhistory

echo "Remediation completed successfully."