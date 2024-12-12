#!/usr/bin/env bash

echo "Starting audit to verify that root user's password is set..."

# Check if root user's password is set
passwd_status=$(passwd -S root | awk '$2 ~ /^P/ {print "User: \"" $1 "\" Password is set"}')

# If the password is set, the status will be printed
if [[ -n "$passwd_status" ]]; then
  echo "$passwd_status"
else
  echo "Fail: Root user does not have a password set."
fi

# Final audit result
echo "Audit complete."
exit 0
