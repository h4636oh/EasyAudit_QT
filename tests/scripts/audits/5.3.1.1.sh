#!/usr/bin/env bash

# For Debian-based systems (if dpkg-query is available)
if command -v dpkg-query &>/dev/null; then
  dpkg-query -s libpam-runtime | grep -P -- '^(Status|Version)\b'
# For Red Hat-based systems
elif command -v rpm &>/dev/null; then
  rpm -q libpam
else
  echo "Unsupported package manager. Please check your system."
  exit 1
fi
