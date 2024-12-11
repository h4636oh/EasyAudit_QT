#!/bin/bash

# Script to audit if the telnet package is not installed.
# This will not attempt to remediate any issues found.

# Check if the telnet package is installed
check_telnet_installed() {
    # Run the rpm command to check for telnet package
    rpm -q telnet &>/dev/null

    # Capture the exit status of the rpm command
    if [ $? -eq 0 ]; then
        return 1  # telnet package is installed
    else
        return 0  # telnet package is not installed
    fi
}

# Invoke the audit function
check_telnet_installed

# Determine the result and exit accordingly
if [ $? -eq 0 ]; then
    echo "Audit Passed: telnet package is not installed."
    exit 0
else
    echo "Audit Failed: telnet package is installed."
    exit 1
fi
