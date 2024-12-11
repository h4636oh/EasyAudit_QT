#!/bin/bash

# Check if journald is being used for logging
echo "Checking if systemd-journal-remote is installed..."

# Run the command to verify systemd-journal-remote is installed
if rpm -q systemd-journal-remote &> /dev/null; then
    echo "Audit Passed: systemd-journal-remote is installed."
    exit 0
else
    echo "Audit Failed: systemd-journal-remote is not installed."
    exit 1
fi
