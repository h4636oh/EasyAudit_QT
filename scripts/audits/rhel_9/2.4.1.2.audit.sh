#!/bin/bash

# Script to audit permissions and ownership of /etc/crontab

# Check if cron is installed by looking for the crontab command
if command -v crontab &> /dev/null; then
    echo "Cron is installed. Proceeding with audit for /etc/crontab file."

    # Fetch current status of /etc/crontab using stat
    crontab_status=$(stat -Lc 'Access: (%a) Uid: (%u) Gid: (%g)' /etc/crontab)

    # Extract permission, UID, and GID values from the output
    current_permission=$(echo "$crontab_status" | awk '{print $2}' | tr -d '()%')
    current_uid=$(echo "$crontab_status" | awk '{print $4}' | tr -d '()%')
    current_gid=$(echo "$crontab_status" | awk '{print $6}' | tr -d '()%')

    # Define the expected state
    expected_permission="600"
    expected_uid="0"
    expected_gid="0"

    # Compare current status with expected state
    if [[ "$current_permission" == "$expected_permission" && "$current_uid" == "$expected_uid" && "$current_gid" == "$expected_gid" ]]; then
        echo "The /etc/crontab file has the correct permissions and ownership."
        exit 0
    else
        echo "The /etc/crontab file does not have the correct permissions or ownership."
        echo "Expected: Access: (600), Uid: (0), Gid: (0)"
        echo "Found: Access: ($current_permission), Uid: ($current_uid), Gid: ($current_gid)"
        # Prompt the user what steps to take manually.
        echo "Please review and fix the permissions and ownership manually."
        exit 1
    fi
else
    echo "Cron is not installed on the system. Skipping the audit for /etc/crontab."
    exit 0
fi
