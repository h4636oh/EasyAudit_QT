#!/usr/bin/env bash

# Check if PASS_WARN_AGE is set to 7 or more in /etc/login.defs
pass_warn_age=$(grep -Pi -- '^\h*PASS_WARN_AGE\h+\d+\b' /etc/login.defs)

if [[ -z "$pass_warn_age" ]]; then
  echo "PASS_WARN_AGE setting not found in /etc/login.defs."
else
  echo "PASS_WARN_AGE setting found in /etc/login.defs:"
  echo "$pass_warn_age"
fi

# Verify all passwords have a PASS_WARN_AGE of 7 or more in /etc/shadow
invalid_users=$(awk -F: '($2~/^\$.+\$/) {if($6 < 7)print "User: " $1 " PASS_WARN_AGE: " $6}' /etc/shadow)

if [[ -z "$invalid_users" ]]; then
  echo "All users have PASS_WARN_AGE set to 7 or more."
else
  echo "The following users have invalid PASS_WARN_AGE settings:"
  echo "$invalid_users"
  exit 1
fi

