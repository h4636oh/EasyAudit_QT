#!/bin/bash

# Title: 6.2.3.1 Ensure rsyslog is installed (Automated)

# Description: The rsyslog software is recommended in environments where journald does not
# meet operation requirements.

# This script audits if rsyslog is installed on the system when rsyslog is the chosen method for client-side logging.
# It will exit with 0 if the rsyslog is installed and with 1 if not.

# Check if rsyslog is planned to be used for logging on this system
echo "Please Only Run This scrip if you are using rsyslog as your logging service."



# If yes, continue to check if rsyslog is installed
echo "Checking if rsyslog is installed..."

# Use rpm package manager to check the installation of rsyslog
rsyslog_status=$(rpm -q rsyslog)

# Check if the output indicates installed rsyslog package
if [[ $? -eq 0 ]]; then
  echo "Audit passed: rsyslog is installed. Output: $rsyslog_status"
  exit 0
else
  echo "Audit failed: rsyslog is not installed."
  exit 1
fi
```

