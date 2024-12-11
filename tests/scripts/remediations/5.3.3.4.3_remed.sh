#!/usr/bin/env bash

echo "Starting remediation for pam_unix.so password hashing algorithm..."

# Define the required hashing algorithm
hash_algorithm="yescrypt"

# Find any files with pam_unix.so and update them to include the strong hashing algorithm (sha512 or yescrypt)
echo "Searching for files with pam_unix.so in /usr/share/pam-configs/..."

# Search for files that contain pam_unix.so and ensure they are updated
awk '/Password-Type:/{ f = 1;next } /-Type:/{ f = 0 } f {if (/pam_unix\.so/) print FILENAME}' /usr/share/pam-configs/* | while read file; do
    echo "Modifying file: $file"

    # Modify the pam_unix.so line to ensure it has sha512 or yescrypt
    sed -ri "s/(pam_unix\.so.*)(obscure.*|.*)(.*)/\1 obscure use_authtok try_first_pass $hash_algorithm/" "$file"

    # Update the pam configuration
    echo "Updating pam configuration for: $file"
    pam-auth-update --enable "$(basename "$file")"
done

# Check for pam_unix.so in /etc/pam.d/ and ensure it has the strong hashing algorithm
echo "Checking and updating pam_unix.so lines in /etc/pam.d/..."

# Iterate over common pam files and modify pam_unix.so entries
for pam_file in /etc/pam.d/common-password /etc/pam.d/common-auth /etc/pam.d/common-account /etc/pam.d/common-session /etc/pam.d/common-session-noninteractive; do
    echo "Checking file: $pam_file"

    # Ensure that pam_unix.so includes a strong hashing algorithm (sha512 or yescrypt)
    if grep -q "pam_unix.so" "$pam_file"; then
        # Modify the pam_unix.so line
        sed -ri "s/(pam_unix\.so.*)(obscure.*|.*)(.*)/\1 obscure use_authtok try_first_pass $hash_algorithm/" "$pam_file"
        echo "Updated pam_unix.so line in: $pam_file"
    else
        echo "No pam_unix.so line found in: $pam_file"
    fi
done

echo "Remediation completed successfully."