#!/bin/bash

# Define the list of PAM configuration files to check
PAM_FILES=("/etc/pam.d/password-auth" "/etc/pam.d/system-auth")

# Check for pam_faillock in the specified files
echo "Checking for pam_faillock module in PAM configuration files..."

for PAM_FILE in "${PAM_FILES[@]}"; do
  if [ -f "$PAM_FILE" ]; then
    echo "Checking $PAM_FILE..."
    if grep -P -- '\bpam_faillock.so\b' "$PAM_FILE" >/dev/null; then
      echo "pam_faillock module is enabled in $PAM_FILE."
    else
      echo "pam_faillock module is NOT enabled in $PAM_FILE."
      exit 1
    fi
  else
    echo "$PAM_FILE does not exist."
    exit 1
  fi
done

echo "Audit complete: pam_faillock is enabled in both files."
exit 0
