#!/bin/bash

# This script audits the configuration of cron to ensure it is restricted to authorized users only.
# Exit 0 if the audit passes, exit 1 if the audit fails.

# Function to check file properties
check_file_properties() {
    local file=$1
    local expected_permissions=$2
    local expected_owner=$3
    local expected_group=$4

    if [ ! -e "$file" ]; then
        echo "$file does not exist."
        return 0
    fi

    local file_stat
    file_stat=$(stat -Lc 'Access: (%a) Owner: (%U) Group: (%G)' "$file")
    local permissions
    permissions=$(echo "$file_stat" | awk -F'[()]' '{print $2 + 0}')
    local owner
    owner=$(echo "$file_stat" | awk '{print $4}')
    local group
    group=$(echo "$file_stat" | awk '{print $6}')

    # Check if file permissions, owner, and group match expected values
    if [[ "$permissions" -le "$expected_permissions" ]] && [[ "$owner" == "$expected_owner" ]] && [[ "$group" == "$expected_group" ]]; then
        return 0
    else
        echo "$file does not have the correct permissions/ownership."
        return 1
    fi
}

# Check if cron is installed
if ! command -v crontab &> /dev/null; then
    echo "Cron is not installed on the system."
    exit 0
fi

audit_passed=true

# Audit /etc/cron.allow
check_file_properties "/etc/cron.allow" 640 "root" "root"
if [ $? -ne 0 ]; then
    audit_passed=false
fi

# Audit /etc/cron.deny if it exists
if [ -e "/etc/cron.deny" ]; then
    check_file_properties "/etc/cron.deny" 640 "root" "root"
    if [ $? -ne 0 ]; then
        audit_passed=false
    fi
fi

# Exit with the appropriate status
if $audit_passed; then
    echo "Audit passed: crontab access is properly restricted."
    exit 0
else
    echo "Audit failed: crontab access is not properly restricted."
    exit 1
fi
