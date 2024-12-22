#!/usr/bin/env bash

# Check for !authenticate entries in /etc/sudoers and /etc/sudoers.d/*
no_authenticate_entries=$(grep -r "^[^#].*\!authenticate" /etc/sudoers /etc/sudoers.d/*)

if [[ -z "$no_authenticate_entries" ]]; then
  echo "No !authenticate entries found. Re-authentication is required for privilege escalation."
else
  echo "!authenticate entries found. Refer to the remediation procedure below:"
  echo "$no_authenticate_entries"
  exit 1
fi

