#!/usr/bin/env bash

echo "Starting PAM Audit for strong password hashing algorithm on pam_unix.so..."

# Define the PAM file to check for password hashing algorithm
PAM_FILE="/etc/pam.d/common-password"

# Flag to track if any failure occurs
PASS=0

# Check if the file exists
if [[ ! -f "$PAM_FILE" ]]; then
  echo "Fail: $PAM_FILE not found."
  exit 1
fi

# Search for pam_unix.so with sha512 or yescrypt password hashing algorithm
echo "Checking $PAM_FILE for strong password hashing algorithm (sha512 or yescrypt)..."

if grep -PH -- '^\h*password\h+([^#\n\r]+)\h+pam_unix\.so\h+([^#\n\r]+\h+)?(sha512|yescrypt)\b' "$PAM_FILE" >/dev/null; then
  echo "Pass: Strong password hashing algorithm (sha512 or yescrypt) found in $PAM_FILE"
else
  echo "Fail: No strong password hashing algorithm (sha512 or yescrypt) found in $PAM_FILE"
  PASS=1
fi

# Audit result
if [ "$PASS" -eq 0 ]; then
  echo "Audit complete. Strong password hashing algorithm is set (Pass)."
  exit 0
else
  echo "Audit complete. Some configurations failed the check (Fail)."
  exit 1
fi
