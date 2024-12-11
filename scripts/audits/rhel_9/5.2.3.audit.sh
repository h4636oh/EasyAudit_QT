#!/bin/bash

# Define the pattern to search for
pattern="^\h*Defaults\h+([^#]+,\h*)?logfile\h*=\h*(\"|\')?\H+(\"|\')?(,\h*\H+\h*)*\h*(#.*)?$"

# Search for the configuration in the sudoers files
result=$(grep -rPsi "$pattern" /etc/sudoers*)

if [ -n "$result" ]; then
  echo "Custom sudo log file is configured:"
  echo "$result"
  exit 0
else
  echo "Custom sudo log file is NOT configured."
  exit 1
fi
