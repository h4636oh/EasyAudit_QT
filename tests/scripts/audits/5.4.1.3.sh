#!/usr/bin/env bash

echo "Starting PAM Audit for PASS_WARN_AGE setting..."

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

# Check if PASS_WARN_AGE is set to 7 or more in /etc/login.defs
echo "Checking $LOGIN_DEFS_FILE for PASS_WARN_AGE setting..."

PASS_WARN_AGE=$(grep -Pi -- '^\h*PASS_WARN_AGE\h+\d+\b' "$LOGIN_DEFS_FILE" | awk '{print $2}')

if [[ -n "$PASS_WARN_AGE" && "$PASS_WARN_AGE" -ge 7 ]]; then
  echo "Pass: PASS_WARN_AGE is set to $PASS_WARN_AGE, which is 7 or more in $LOGIN_DEFS_FILE"
else
  echo "Fail: PASS_WARN_AGE is not set to 7 or more in $LOGIN_DEFS_FILE"
  PASS=1
fi

# Check if any users in /etc/shadow have PASS_WARN_AGE less than 7
echo "Checking $SHADOW_FILE for users with PASS_WARN_AGE less than 7..."

if awk -F: '($2~/^\$.+\$/) {if($6 < 7)print "User: " $1 " PASS_WARN_AGE: " $6}' "$SHADOW_FILE" | grep -q .; then
  echo "Fail: Some users in $SHADOW_FILE have PASS_WARN_AGE less than 7."
  PASS=1
else
  echo "Pass: All users in $SHADOW_FILE have PASS_WARN_AGE of 7 or more."
fi

# Audit result
if [ "$PASS" -eq 0 ]; then
  echo "Audit complete. PASS_WARN_AGE is correctly configured (Pass)."
  exit 0
else
  echo "Audit complete. PASS_WARN_AGE failed the check (Fail)."
  exit 1
fi
