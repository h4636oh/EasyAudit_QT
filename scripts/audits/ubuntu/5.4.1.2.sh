#!/usr/bin/env bash

echo "Starting PAM Audit for PASS_MIN_DAYS setting..."

# Define the login.defs and shadow files to check
LOGIN_DEFS_FILE="/etc/login.defs"
SHADOW_FILE="/etc/shadow"

# Flag to track if any failure occurs
PASS=0

# Check if the login.defs file exists
if [[ ! -f "$LOGIN_DEFS_FILE" ]]; then
  echo "Fail: $LOGIN_DEFS_FILE not found."
  exit 1
fi

# Check if the shadow file exists
if [[ ! -f "$SHADOW_FILE" ]]; then
  echo "Fail: $SHADOW_FILE not found."
  exit 1
fi

# Check if PASS_MIN_DAYS is set to a value greater than 0 in /etc/login.defs
echo "Checking $LOGIN_DEFS_FILE for PASS_MIN_DAYS setting..."

PASS_MIN_DAYS=$(grep -Pi -- '^\h*PASS_MIN_DAYS\h+\d+\b' "$LOGIN_DEFS_FILE" | awk '{print $2}')

if [[ -n "$PASS_MIN_DAYS" && "$PASS_MIN_DAYS" -gt 0 ]]; then
  echo "Pass: PASS_MIN_DAYS is set to $PASS_MIN_DAYS, which is greater than 0 in $LOGIN_DEFS_FILE"
else
  echo "Fail: PASS_MIN_DAYS is not set to a value greater than 0 in $LOGIN_DEFS_FILE"
  PASS=1
fi

# Check if any users in /etc/shadow have PASS_MIN_AGE less than 1
echo "Checking $SHADOW_FILE for users with PASS_MIN_AGE less than 1..."

if awk -F: '($2~/^\$.+\$/) {if($4 < 1)print "User: " $1 " PASS_MIN_DAYS: " $4}' "$SHADOW_FILE" | grep -q .; then
  echo "Fail: Some users in $SHADOW_FILE have PASS_MIN_AGE less than 1."
  PASS=1
else
  echo "Pass: All users in $SHADOW_FILE have PASS_MIN_AGE greater than 0."
fi

# Audit result
if [ "$PASS" -eq 0 ]; then
  echo "Audit complete. PASS_MIN_DAYS is correctly configured (Pass)."
  exit 0
else
  echo "Audit complete. PASS_MIN_DAYS failed the check (Fail)."
  exit 1
fi
