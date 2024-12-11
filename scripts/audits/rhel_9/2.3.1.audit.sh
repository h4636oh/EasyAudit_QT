#!/bin/bash

# This script audits if the 'chrony' package is installed on the system for time synchronization purposes.
# It exits with 0 if 'chrony' is installed, indicating compliance, and 1 if not installed or an issue arises, indicating non-compliance.

# Function to check if 'chrony' is installed
check_chrony_installed() {
    # Check if the 'chrony' package is installed using rpm
    if rpm -q chrony &> /dev/null; then
        echo "Audit Passed: 'chrony' is installed."
        exit 0
    else
        echo "Audit Failed: 'chrony' is not installed."
        # Prompt the user for manual verification or installation
        echo "Please ensure that 'chrony' is installed or consult your documentation for other time synchronization methods."
        exit 1
    fi
}

# Run the check for 'chrony'
check_chrony_installed
