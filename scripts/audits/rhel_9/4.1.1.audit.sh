#!/bin/bash

# Auditing script for checking if nftables is installed
# Profile Applicability: Level 1 - Server, Level 1 - Workstation
# Description: This script checks if nftables package is installed on the system.

# Function to perform audit
audit_nftables_installed() {
    # Run the command to check if nftables is installed
    nftables_status=$(rpm -q nftables)

    # Validate the output
    if [[ $nftables_status == nftables-* ]]; then
        echo "PASS: nftables is installed."
        exit 0
    else
        echo "FAIL: nftables is not installed."
        echo "Please install nftables using 'dnf install nftables' command."
        exit 1
    fi
}

# Execute the audit function
audit_nftables_installed