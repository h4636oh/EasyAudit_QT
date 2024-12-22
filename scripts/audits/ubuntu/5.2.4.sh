#!/usr/bin/env bash

# Check for NOPASSWD entries in /etc/sudoers and /etc/sudoers.d/*
nopasswd_entries=$(grep -r "^[^#].*NOPASSWD" /etc/sudoers /etc/sudoers.d/*)

if [[ -z "$nopasswd_entries" ]]; then
  echo "No NOPASSWD entries found. Password is required for privilege escalation."
else
  echo "NOPASSWD entries found. Refer to the remediation procedure below:"
  echo "$nopasswd_entries"
  exit 1
fi

