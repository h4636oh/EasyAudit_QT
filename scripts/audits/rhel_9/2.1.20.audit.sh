#!/bin/bash

# Script to audit the presence of X Windows Server packages
# Exit 0 if the audit passes (i.e., package is not installed), exit 1 if it fails.

# Function to check if xorg-x11-server-common package is installed
audit_x_window_server() {
    local package_status
    package_status=$(rpm -q xorg-x11-server-common)

    if [[ "$package_status" == "package xorg-x11-server-common is not installed" ]]; then
        echo "Audit Passed: X Windows Server package is not installed."
        exit 0
    else
        echo "Audit Failed: X Windows Server package is installed."
        exit 1
    fi
}

# Inform the user about manual verification requirements based on site policy
echo "Manual Verification: Ensure that a Graphical Desktop Manager or X-Windows server is not required and approved by your local site policy."

# Perform the audit
audit_x_window_server
