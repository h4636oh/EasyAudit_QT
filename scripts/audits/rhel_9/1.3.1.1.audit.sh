#!/bin/bash

# Script to audit if SELinux is installed
# Profile Applicability: Level 1 - Server, Level 1 - Workstation
# Description: SELinux provides Mandatory Access Control.

# Function to check if SELinux is installed
check_selinux_installed() {
    if rpm -q libselinux > /dev/null 2>&1; then
        echo "SELinux is installed."
        return 0
    else
        echo "SELinux is NOT installed."
        return 1
    fi
}

# Run the audit
check_selinux_installed
audit_result=$?

# Exit with appropriate code
if [ $audit_result -eq 0 ]; then
    exit 0  # Audit passed
else
    echo "Please install SELinux manually using the following command:" 
    echo "dnf install libselinux"
    exit 1  # Audit failed
fi
