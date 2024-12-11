#!/bin/bash

# This script audits whether the noexec option is set on the /var/log partition.
# It ensures that no executable binaries can run from /var/log, as it's intended for log files only.

# Audit: Check if the noexec option is set for /var/log

# Check if /var/log is mounted, and if so, ensure noexec is among the options.
output=$(findmnt -kn /var/log | grep -v noexec)

if [ -z "$output" ]; then
  echo "Audit Passed: The noexec option is set for the /var/log partition."
  exit 0
else
  echo "Audit Failed: The noexec option is NOT set for the /var/log partition."
  echo "Please manually edit /etc/fstab to add noexec to the /var/log partition options."
  exit 1
fi