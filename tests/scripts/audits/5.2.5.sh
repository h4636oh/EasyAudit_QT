#!/usr/bin/env bash

# Check for lines with '!authenticate' in the sudoers files
if grep -rF "!authenticate" /etc/sudoers* 2>/dev/null > /dev/null; then
  echo "FAIL: Re-authentication for privilege escalation is not required."
  exit 1
else
  echo "PASS: Re-authentication for privilege escalation is required."
  exit 0
fi
