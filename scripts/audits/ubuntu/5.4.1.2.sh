#!/usr/bin/env bash

# Define the minimum days for password change
MIN_DAYS=1

echo "Checking PASS_MIN_DAYS in /etc/login.defs..."
grep -Pi '^\h*PASS_MIN_DAYS\h+\d+\b' /etc/login.defs || echo "PASS_MIN_DAYS not set in /etc/login.defs!"

echo
echo "Validating that all users have PASS_MIN_DAYS >= $MIN_DAYS in /etc/shadow..."
non_compliant_users=$(awk -F: '($2~/^\$.+\$/) {if($4 < 1) print "User: " $1 " PASS_MIN_DAYS: " $4}' /etc/shadow)

if [ -n "$non_compliant_users" ]; then
    echo "Non-compliant users found:"
    echo "$non_compliant_users"
    exit 1
else
    echo "All users are compliant with PASS_MIN_DAYS >= $MIN_DAYS."
fi
