#!/bin/bash

# Script to audit the FTP client installation status
# Ensures that the FTP client is not installed on the system
# Exits with 0 if FTP client is not installed, 1 if it is installed

# Check if FTP client is installed
FTP_STATUS=$(rpm -q ftp)

# Audit the result of the command
if [[ "$FTP_STATUS" == "package ftp is not installed" ]]; then
    echo "PASSED: FTP client is not installed."
    exit 0
else
    echo "FAILED: FTP client is installed."
    echo "Please manually remove the FTP client if it is not needed."
    echo "Run the command: dnf remove ftp"
    exit 1
fi

