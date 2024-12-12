#!/bin/bash

# This script audits whether login and logout events are being monitored
# as per the specifications given in the provided input.

# Function to audit on-disk configuration
audit_on_disk() {
  echo "Checking on-disk configuration..."
  local on_disk_output
  on_disk_output=$(awk '/^ *-w/ \
    &&(/\/var\/log\/lastlog/ \
    ||/\/var\/run\/faillock/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

  local expected_output="-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock -p wa -k logins"

  if [[ "$on_disk_output" == "$expected_output" ]]; then
    echo "On-disk configuration is correct."
    return 0
  else
    echo "On-disk configuration is incorrect."
    return 1
  fi
}

# Function to audit running configuration
audit_running_config() {
  echo "Checking running configuration..."
  local running_output
  running_output=$(auditctl -l | awk '/^ *-w/ \
    &&(/\/var\/log\/lastlog/ \
    ||/\/var\/run\/faillock/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)')

  local expected_output="-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock -p wa -k logins"

  if [[ "$running_output" == "$expected_output" ]]; then
    echo "Running configuration is correct."
    return 0
  else
    echo "Running configuration is incorrect."
    return 1
  fi
}

# Main function
main() {
  audit_on_disk
  local on_disk_status=$?

  audit_running_config
  local running_status=$?

  if [[ $on_disk_status -eq 0 && $running_status -eq 0 ]]; then
    echo "Audit passed."
    exit 0
  else
    echo "Audit failed."
    exit 1
  fi
}

# Run the main function
main
