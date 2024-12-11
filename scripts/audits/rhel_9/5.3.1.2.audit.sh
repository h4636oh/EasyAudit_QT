#!/bin/bash

# Define the minimum required version of authselect
MIN_VERSION="1.2.6-2"

# Get the installed version of authselect
INSTALLED_VERSION=$(rpm -q --queryformat '%{VERSION}-%{RELEASE}' authselect 2>/dev/null)

# Check if authselect is installed
if [ $? -ne 0 ]; then
  echo "authselect is not installed on the system."
  exit 1
fi

# Compare the installed version with the minimum required version
if [ "$(echo -e "$INSTALLED_VERSION\n$MIN_VERSION" | sort -V | head -n 1)" = "$MIN_VERSION" ] || [ "$INSTALLED_VERSION" = "$MIN_VERSION" ]; then
  echo "authselect version $INSTALLED_VERSION meets the required version $MIN_VERSION."
  exit 0
else
  echo "authselect version $INSTALLED_VERSION does NOT meet the required version $MIN_VERSION."
  exit 1
fi
