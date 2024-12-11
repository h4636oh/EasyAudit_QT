#!/bin/bash

# Script to audit if the 'nosuid' option is set on the /tmp partition
# Exits 0 if the audit passes, exits 1 if it fails

# Check if a separate partition exists for /tmp and if it's mounted with the nosuid option
output=$(findmnt -kn /tmp | grep -v nosuid)

if [ -z "$output" ]; then
  echo "Audit passed: The 'nosuid' option is set on the /tmp partition."
  exit 0
else
  echo "Audit failed: The 'nosuid' option is NOT set on the /tmp partition."
  echo "To remediate, manually edit the /etc/fstab file to add 'nosuid' to the /tmp partition options."
  exit 1
fi

