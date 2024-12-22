#!/usr/bin/env bash

# Check PermitEmptyPasswords in the main configuration
permit_empty_passwords=$(sshd -T | grep permitemptypasswords)

if [[ "$permit_empty_passwords" == "permitemptypasswords no" ]]; then
  echo "PermitEmptyPasswords is set to no"
else
  echo "PermitEmptyPasswords is not set to no in the main configuration"
  exit 1
fi

# Check PermitEmptyPasswords in match blocks
check_match_block() {
  local user="$1"
  permit_empty_passwords_match=$(sshd -T -C user="$user" | grep permitemptypasswords)
  
  if [[ "$permit_empty_passwords_match" == "permitemptypasswords no" ]]; then
    echo "PermitEmptyPasswords is set to no for user $user in match block"
  else
    echo "PermitEmptyPasswords is not set to no for user $user in match block"
    exit 1
  fi
}

# Example check for a specific user (sshuser)
# Adjust this part as needed for your environment
check_match_block "sshuser"

# Additional checks can be added here by calling the check_match_block function with different parameters

