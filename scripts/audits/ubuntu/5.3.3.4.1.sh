#!/usr/bin/env bash

# Check if PASS_MAX_DAYS is set to 365 days or less in /etc/login.defs
pass_max_days=$(grep -Pi -- '^\h*PASS_MAX_DAYS\h+\d+\b' /etc/login.defs)

if [[ -z "$pass_max_days" ]]; then
  echo "PASS_MAX_DAYS setting not found in /etc/login.defs."
else
  echo "PASS_MAX_DAYS setting found in /etc/login.defs:"
  echo "$pass_max_days"
fi

# Verify all user passwords have PASS_MAX_DAYS of 365 days or less and greater than 0 days in /etc/shadow
invalid_users=$(awk -F: '($2~/^\$.+\$/) {if($5 > 365 || $5 < 1) print "User: " $1 " PASS_MAX_DAYS: " $5}' /etc/shadow)

if [[ -z "$invalid_users" ]]; then
  echo "All users have PASS_MAX_DAYS set to 365 days or less and greater than 0 days."
else
  echo "The following users have invalid PASS_MAX_DAYS settings:"
  echo "$invalid_users"
  exit 1
fi

