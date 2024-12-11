#!/bin/bash

# This script audits whether the cron daemon is installed, enabled, and active.

# Function to check if cron service is installed
check_cron_installed() {
    if systemctl list-unit-files | grep -qE '^crond?\.service'; then
        return 0
    else
        return 1
    fi
}

# Function to check if cron service is enabled
check_cron_enabled() {
    local status
    status=$(systemctl list-unit-files | awk '$1~/^crond?\.service/{print $2}')
    if [[ "$status" == "enabled" ]]; then
        return 0
    else
        return 1
    fi
}

# Function to check if cron is active
check_cron_active() {
    local state
    state=$(systemctl list-units --type=service | awk '$1~/^crond?\.service/{print $3}')
    if [[ "$state" == "active" ]]; then
        return 0
    else
        return 1
    fi
}

# Main audit function
main_audit() {
    if check_cron_installed; then
        echo "Cron service is installed."
        if check_cron_enabled && check_cron_active; then
            echo "Cron service is enabled and active."
            exit 0
        else
            echo "Cron service is not enabled or not active."
            exit 1
        fi
    else
        echo "Cron service is not installed."
        echo "Please ensure cron is installed, enabled, and active."
        exit 1
    fi
}

# Run the main audit function
main_audit

