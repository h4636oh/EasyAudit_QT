#!/bin/bash

# This script audits the /etc/issue.net file for compliance with site policy regarding login banners.

# Function to check the contents of /etc/issue.net
check_issue_net() {
  local is_compliant=0
  
  # Check the contents of /etc/issue.net file
  echo "Checking the contents of /etc/issue.net..."
  echo "------------------------------------------------"
  cat /etc/issue.net
  echo "------------------------------------------------"
  
  # Prompt user to verify the content manually
  echo "Verify that the above contents match your site policy."

  # Check for forbidden patterns: \v, \r, \m, \s, and OS platform references
  echo "Ensuring there are no forbidden patterns or OS platform references..."
  local forbidden_patterns=$(grep -E -i "(\\\\\\v|\\\\\\r|\\\\\\m|\\\\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/\"//g'))" /etc/issue.net)

  # If forbidden patterns are found, set is_compliant to 1
  if [[ ! -z "$forbidden_patterns" ]]; then
    echo "The following forbidden patterns were found in /etc/issue.net:"
    echo "$forbidden_patterns"
    is_compliant=1
  fi

  return $is_compliant
}

# Main audit function
main_audit() {
  check_issue_net

  # Determine the result based on compliance
  if [[ $? -eq 0 ]]; then
    echo "Audit Passed: /etc/issue.net file is compliant."
    exit 0
  else
    echo "Audit Failed: /etc/issue.net file is not compliant."
    exit 1
  fi
}

# Execute the main audit function
main_audit
