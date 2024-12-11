#!/bin/bash

# This script audits the SELinux mode on a system to ensure it's not set to "disabled".
# The audit involves checking both the current mode and the configured mode.

# Function to check if SELinux is not disabled
function check_selinux_mode() {
    # Check the current SELinux enforcing status
    current_mode=$(getenforce)
    
    # Check the configured SELinux mode in the configuration file
    configured_mode=$(grep -Ei '^\s*SELINUX=(enforcing|permissive)' /etc/selinux/config | awk -F= '{print $2}')

    if [[ "$current_mode" == "Disabled" ]]; then
        echo "Audit Failed: SELinux is currently disabled."
        exit 1
    fi

    if [[ -z "$configured_mode" ]]; then
        echo "Audit Failed: SELinux configuration not found or improperly set."
        exit 1
    fi

    if [[ "$configured_mode" != "enforcing" && "$configured_mode" != "permissive" ]]; then
        echo "Audit Failed: SELINUX in /etc/selinux/config is set to: '$configured_mode'. It should be 'enforcing' or 'permissive'."
        exit 1
    fi

    echo "Audit Passed: SELinux is set correctly."
    exit 0
}

# Function to prompt the user to manually verify the SELinux status
function manual_verification_prompt() {
    echo "Please verify SELinux's current mode manually by running the following command:"
    echo "# getenforce"
    echo "Ensure it is not 'Disabled'."
    echo "Also, verify the configuration file /etc/selinux/config contains SELINUX=enforcing or SELINUX=permissive."
}

# Run the audit function
check_selinux_mode

# In case the script reaches this point, remind the user to verify manually
manual_verification_prompt