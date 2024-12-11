#!/bin/bash

# Script to audit the dnsmasq service and package status
# This script checks if the dnsmasq package is not installed, or if it is, checks that the service is neither enabled nor active.

# Function to display a message and wait for the user
prompt_manual_step() {
    local message="$1"
    echo "$message"
    echo "Please address the issue manually, then press Enter to continue."
    read -r
}

# Check if dnsmasq package is not installed
if rpm -q dnsmasq &>/dev/null; then
    echo "dnsmasq package is installed."

    # Check if the dnsmasq service is enabled
    if systemctl is-enabled dnsmasq.service 2>/dev/null | grep -q 'enabled'; then
        echo "Audit Failed: dnsmasq.service is enabled."
        exit 1
    fi

    # Check if the dnsmasq service is active
    if systemctl is-active dnsmasq.service 2>/dev/null | grep -q '^active'; then
        echo "Audit Failed: dnsmasq.service is active."
        exit 1
    fi

    echo "Audit Passed: dnsmasq package is installed but the service is not enabled or active."

else
    echo "Audit Passed: dnsmasq package is not installed."
fi

exit 0