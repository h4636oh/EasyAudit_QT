#!/bin/bash

# This script audits the configuration of firewalld to ensure it complies with site policy.
# Specifically, it checks that unnecessary services and ports are not enabled.

# Exit the script if any command fails
set -e

# Check if firewalld.service is enabled and run the audit command if it is.
if systemctl is-enabled firewalld.service | grep -q 'enabled'; then
  echo "Firewalld is enabled. Checking active zones for unnecessary services and ports..."
  
  # List services and ports for the currently active zone
  active_zone=$(firewall-cmd --get-active-zones | awk 'NR==1{print $1}')
  firewall_output=$(firewall-cmd --list-all --zone="$active_zone" | grep -P -- '^\h*(services:|ports:)')

  echo "Audit Result for zone: $active_zone"
  echo "$firewall_output"

  # Prompt user to manually verify compliance with site policy
  echo "Please review the listed services and ports above."
  echo "Ensure they adhere to the site policy guidelines."
  echo "Allow port 22 (ssh) only for systems requiring ssh connectivity as per site policy."

  # If any services or ports are listed, exit 1 indicating the audit failed
  if [ -n "$firewall_output" ]; then
    echo "Audit FAIL: The audit has found services or ports enabled that need to be reviewed."
    exit 1
  else
    echo "Audit PASS: All active services and ports comply with site policy."
    exit 0
  fi

else
  echo "Audit PAUSED: Firewalld is not enabled. No further audit is required."
  exit 0
fi
