#!/bin/bash

# Function: audit_selinux_mode
# Description: This function checks if SELinux is set to enforcing mode.
# It checks both the current mode and the configured mode in the configuration file.

audit_selinux_mode() {
    # Check the current SELinux mode
    current_mode=$(getenforce)
    if [[ "$current_mode" != "Enforcing" ]]; then
        echo "Audit Failed: Current SELinux mode is not Enforcing. Current mode: $current_mode"
        exit 1
    fi

    # Check the configured SELinux mode in /etc/selinux/config
    configured_mode=$(grep -i "^SELINUX=" /etc/selinux/config | awk -F= '{print $2}')
    if [[ "$configured_mode" != "enforcing" ]]; then
        echo "Audit Failed: Configured SELinux mode is not Enforcing. Configured mode: $configured_mode"
        exit 1
    fi

    echo "Audit Passed: SELinux is in Enforcing mode both currently and in the configuration."
    exit 0
}

# Run the audit
audit_selinux_mode

# Explanation:
# - The script defines a function `audit_selinux_mode` that checks both the current and configured SELinux modes.
# - `getenforce` is used to determine the current SELinux mode.
# - `/etc/selinux/config` is checked to ensure the configured SELinux mode is set to enforcing.
# - The script exits with status 1 if either the current or configured mode is not enforcing, otherwise, it exits with status 0 indicating a successful audit.