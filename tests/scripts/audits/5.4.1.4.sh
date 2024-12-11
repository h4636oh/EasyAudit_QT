#!/usr/bin/env bash

echo "Starting PAM Audit for ENCRYPT_METHOD setting..."

# Define the login.defs file to check
LOGIN_DEFS_FILE="/etc/login.defs"

# Flag to track if any failure occurs
PASS=0

# Check if the login.defs file exists
if [[ ! -f "$LOGIN_DEFS_FILE" ]]; then
  echo "Fail: $LOGIN_DEFS_FILE not found."
  exit 1
fi

# Check if ENCRYPT_METHOD is set to SHA512 or yescrypt in /etc/login.defs
echo "Checking $LOGIN_DEFS_FILE for ENCRYPT_METHOD setting..."

ENCRYPT_METHOD=$(grep -Pi -- '^\h*ENCRYPT_METHOD\h+(SHA512|yescrypt)\b' "$LOGIN_DEFS_FILE" | awk '{print $2}')

if [[ -n "$ENCRYPT_METHOD" && ( "$ENCRYPT_METHOD" == "SHA512" || "$ENCRYPT_METHOD" == "YESCRYPT" ) ]]; then
  echo "Pass: ENCRYPT_METHOD is set to $ENCRYPT_METHOD in $LOGIN_DEFS_FILE"
else
  echo "Fail: ENCRYPT_METHOD is not set to SHA512 or YESCRYPT in $LOGIN_DEFS_FILE"
  PASS=1
fi

# Audit result
if [ "$PASS" -eq 0 ]; then
  echo "Audit complete. ENCRYPT_METHOD is correctly configured (Pass)."
  exit 0
else
  echo "Audit complete. ENCRYPT_METHOD failed the check (Fail)."
  exit 1
fi
