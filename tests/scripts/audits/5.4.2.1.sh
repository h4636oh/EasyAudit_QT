#!/usr/bin/env bash

echo "Starting audit to verify that only 'root' has UID 0..."

# Check that only the root user has UID 0
if [[ $(awk -F: '($3 == 0) { print $1 }' /etc/passwd) == "root" ]]; then
  echo "Pass: Only 'root' has UID 0."
else
  echo "Fail: There are users other than 'root' with UID 0."
fi

# Final audit result
echo "Audit complete."
exit 0
