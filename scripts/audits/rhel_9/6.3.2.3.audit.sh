#!/bin/bash

# This script audits the configuration of 'auditd' for handling full disk space and errors.
# It checks the settings in /etc/audit/auditd.conf and verifies that they align with security requirements.
# It should only audit and prompt the user to take action manually if required.

# Paths
AUDITD_CONF="/etc/audit/auditd.conf"

# Check if auditd configuration file exists
if [ ! -f "$AUDITD_CONF" ]; then
  echo "Auditd configuration file not found at $AUDITD_CONF"
  exit 1
fi

# Function to audit disk_full_action
audit_disk_full_action() {
  grep_output=$(grep -P -- '^\h*disk_full_action\h*=\h*(halt|single)\b' "$AUDITD_CONF")
  if [ -z "$grep_output" ]; then
    echo "disk_full_action is NOT set to 'halt' or 'single' in $AUDITD_CONF"
    echo "Please manually set 'disk_full_action' to either 'halt' or 'single'."
    return 1
  else
    echo "disk_full_action is correctly set in $AUDITD_CONF"
    return 0
  fi
}

# Function to audit disk_error_action
audit_disk_error_action() {
  grep_output=$(grep -P -- '^\h*disk_error_action\h*=\h*(syslog|single|halt)\b' "$AUDITD_CONF")
  if [ -z "$grep_output" ]; then
    echo "disk_error_action is NOT set to 'syslog', 'single', or 'halt' in $AUDITD_CONF"
    echo "Please manually set 'disk_error_action' to 'syslog', 'single', or 'halt'."
    return 1
  else
    echo "disk_error_action is correctly set in $AUDITD_CONF"
    return 0
  fi
}

# Run audits
audit_disk_full_action
disk_full_action_result=$?

audit_disk_error_action
disk_error_action_result=$?

# Determine overall audit result
if [ $disk_full_action_result -eq 0 ] && [ $disk_error_action_result -eq 0 ]; then
  exit 0
else
  exit 1
fi
```