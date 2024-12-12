#!/usr/bin/env bash

echo "Starting audit to verify root user's primary GID is 0 and no other user has GID 0..."

# Check for users with GID 0, excluding certain system users
output=$(awk -F: '($1 !~ /^(sync|shutdown|halt|operator)/ && $4=="0") {print $1 ":" $4}' /etc/passwd)

# Check if output matches expected "root:0"
if [[ "$output" == "root:0" ]]; then
  echo "Pass: Only 'root' has primary GID 0."
else
  echo "Fail: There are users other than 'root' with primary GID 0."
  echo "Users with GID 0: $output"
fi

# Final audit result
echo "Audit complete."
exit 0
