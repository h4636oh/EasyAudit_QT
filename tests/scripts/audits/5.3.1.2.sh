#!/usr/bin/env bash

# Check if libpam-modules is installed and get its version
if dpkg-query -s libpam-modules &>/dev/null; then
  # Fetch the version of libpam-modules
  version=$(dpkg-query -s libpam-modules | grep -P -- 'Version' | awk '{print $2}')
  
  # Compare the installed version with 1.5.2-6
  required_version="1.5.2-6"
  
  if dpkg --compare-versions "$version" ge "$required_version"; then
    echo "PASS: libpam-modules is installed and version is $version (>= $required_version)."
  else
    echo "FAIL: libpam-modules version is $version, which is older than $required_version."
    exit 1
  fi
else
  echo "FAIL: libpam-modules is not installed."
  exit 1
fi
