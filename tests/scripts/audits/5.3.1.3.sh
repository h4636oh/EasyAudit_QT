#!/usr/bin/env bash

# Check if libpam-pwquality is installed
if dpkg-query -s libpam-pwquality &>/dev/null; then
  # Fetch the status and version of libpam-pwquality
  status=$(dpkg-query -s libpam-pwquality | grep -P '^Status\b')
  version=$(dpkg-query -s libpam-pwquality | grep -P '^Version\b' | awk '{print $2}')
  
  echo "PASS: libpam-pwquality is installed."
  echo "$status"
  echo "Version: $version"
else
  echo "FAIL: libpam-pwquality is not installed."
  exit 1
fi
