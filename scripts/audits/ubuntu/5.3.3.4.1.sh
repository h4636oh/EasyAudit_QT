#!/usr/bin/env bash

echo "Starting PAM Audit for pam_unix.so and the 'nullok' argument..."

# Define the list of PAM configuration files to check
PAM_FILES=(
  "/etc/pam.d/common-password"
  "/etc/pam.d/common-auth"
  "/etc/pam.d/common-account"
  "/etc/pam.d/common-session"
  "/etc/pam.d/common-session-noninteractive"
)

# Iterate through each PAM file and check for pam_unix.so entries with 'nullok'
for FILE in "${PAM_FILES[@]}"; do
  echo "Checking $FILE for pam_unix.so entries with 'nullok' argument..."
  
  # Search for pam_unix.so and check if 'nullok' is not present
  grep -P '^\s*[^#\n\r]+\s+pam_unix\.so\b' "$FILE" | grep -Pv '\bnullok\b' || echo "No 'nullok' found in $FILE"
done

echo "Audit complete."