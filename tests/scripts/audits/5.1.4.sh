#!/usr/bin/env bash

# Verify SSH configuration for Allow/Deny Users or Groups
sshd_output=$(sshd -T | grep -Pi -- '^\h*(allow|deny)(users|groups)\h+\H+')

if [ -z "$sshd_output" ]; then
  echo "FAIL: No AllowUsers, AllowGroups, DenyUsers, or DenyGroups settings found."
  exit 1
else
  echo "PASS: Found Allow/Deny Users or Groups settings:"
  echo "$sshd_output"
  exit 0
fi

# Example: Checking a specific user (e.g., sshuser) in a Match block
match_user_output=$(sshd -T -C user=sshuser | grep -Pi -- '^\h*(allow|deny)(users|groups)\h+\H+')

if [ -z "$match_user_output" ]; then
  echo "FAIL: No Allow/Deny Users or Groups settings found for user sshuser."
  exit 1
else
  echo "PASS: Found Allow/Deny Users or Groups settings for user sshuser:"
  echo "$match_user_output"
  exit 0
fi
