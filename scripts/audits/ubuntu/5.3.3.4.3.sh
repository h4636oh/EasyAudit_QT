#!/usr/bin/env bash

echo "Starting PAM Audit for pam_unix.so and the 'remember' argument..."

# Define the list of PAM configuration files to check
PAM_FILES=(
  "/etc/pam.d/common-password"
  "/etc/pam.d/common-auth"
  "/etc/pam.d/common-account"
  "/etc/pam.d/common-session"
  "/etc/pam.d/common-session-noninteractive"
)

# Flag to track if any failure occurs
PASS=0

# Iterate through each PAM file and check for pam_unix.so entries with 'remember' argument
for FILE in "${PAM_FILES[@]}"; do
  echo "Checking $FILE for pam_unix.so entries with 'remember' argument..."
  
  # Check if the file exists before proceeding
  if [[ ! -f "$FILE" ]]; then
    continue
  fi
  
  # Search for pam_unix.so and check if 'remember' is present
  if grep -PH -- '^\h*^\h*[^#\n\r]+\h+pam_unix\.so\b' "$FILE" | grep -Pv '\bremember=\d+\b' >/dev/null; then
    echo "Fail: 'remember' argument found in $FILE"
    PASS=1
  else
    echo "Pass: 'remember' argument not found in $FILE"
  fi
done

# Audit result
if [ "$PASS" -eq 0 ]; then
  echo "Audit complete. All PAM configurations are correctly configured (Pass)."
  exit 0
else
  echo "Audit complete. Some PAM configurations failed the check (Fail)."
  exit 1
fi
