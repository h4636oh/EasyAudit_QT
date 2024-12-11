#!/usr/bin/env bash

echo "Starting PAM Audit for PASS_MAX_DAYS setting..."

# Define the login.defs file to check
LOGIN_DEFS_FILE="/etc/login.defs"

# Flag to track if any failure occurs
PASS=0

# Check if the file exists
if [[ ! -f "$LOGIN_DEFS_FILE" ]]; then
  echo "Fail: $LOGIN_DEFS_FILE not found."
  exit 1
fi

# Search for PASS_MAX_DAYS and check if it's set to 365 or less
echo "Checking $LOGIN_DEFS_FILE for PASS_MAX_DAYS setting..."

PASS_MAX_DAYS=$(grep -Pi -- '^\h*PASS_MAX_DAYS\h+\d+\b' "$LOGIN_DEFS_FILE" | awk '{print $2}')

if [[ -n "$PASS_MAX_DAYS" && "$PASS_MAX_DAYS" -le 365 ]]; then
  echo "Pass: PASS_MAX_DAYS is set to $PASS_MAX_DAYS days or less in $LOGIN_DEFS_FILE"
else
  echo "Fail: PASS_MAX_DAYS is not set to 365 days or less in $LOGIN_DEFS_FILE"
  PASS=1
fi

# Audit result
if [ "$PASS" -eq 0 ]; then
  echo "Audit complete. PASS_MAX_DAYS is correctly configured (Pass)."
  exit 0
else
  echo "Audit complete. PASS_MAX_DAYS failed the check (Fail)."
  exit 1
fi
