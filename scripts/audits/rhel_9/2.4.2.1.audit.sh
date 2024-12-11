#!/usr/bin/env bash

# Script to audit the permissions and existence of /etc/at.allow and /etc/at.deny
# This script is for audit purposes only and will not make any changes.

# Checks if 'at' command is available, implying 'at' is installed
if ! command -v at &>/dev/null; then
  echo "'at' command is not installed on the system. Nothing to audit."
  exit 0
fi

# Function to verify file permissions and properties
function verify_file {
  local file=$1
  if [ -e "$file" ]; then
    local result=$(stat -Lc 'Access: (%a) Owner: (%U) Group: (%G)' "$file")
    local permissions=$(echo "$result" | awk -F'[()]' '{print $2 + 0}')
    local owner=$(echo "$result" | awk '{print $4}')
    local group=$(echo "$result" | awk '{print $6}')
    
    # Check file permissions, owner, and group for compliance
    if [ $permissions -le 640 ] && [ "$owner" == "root" ]; then
        if [ "$group" == "daemon" ] || [ "$group" == "root" ]; then
            echo "$file is correctly configured."
        else
            echo "Audit failed: $file group is incorrect."
            exit 1
        fi
    else
      echo "Audit failed: $file permissions or ownership is incorrect."
      exit 1
    fi
  else
    echo "$file does not exist."
  fi
}

# Verify /etc/at.allow
verify_file /etc/at.allow

# Verify /etc/at.deny
if [ -e "/etc/at.deny" ]; then
  verify_file /etc/at.deny
else
  echo "/etc/at.deny does not exist, which is permissible."
fi

echo "All checks passed. The system is compliant."
exit 0