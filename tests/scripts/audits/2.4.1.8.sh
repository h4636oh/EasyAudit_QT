#!/bin/bash

# Check if cron is installed
if command -v crontab >/dev/null 2>&1; then
    echo "cron is installed"

    # Verify /etc/cron.allow
    if [ -e /etc/cron.allow ]; then
        cron_allow_status=$(stat -Lc 'Access: (%a/%A) Owner: (%U) Group: (%G)' /etc/cron.allow)
        echo "$cron_allow_status"
        # Check if the conditions are met
        if [[ "$cron_allow_status" == *"Access: (640/-rw-r-----) Owner: (root) Group: (root)"* ]]; then
            echo "/etc/cron.allow permissions and ownership are correctly set."
        else
            echo "/etc/cron.allow permissions or ownership are not correctly set."
            exit 1
        fi
    else
        echo "/etc/cron.allow does not exist."
        exit 1
    fi

    # Verify /etc/cron.deny
    if [ -e /etc/cron.deny ]; then
        cron_deny_status=$(stat -Lc 'Access: (%a/%A) Owner: (%U) Group: (%G)' /etc/cron.deny)
        echo "$cron_deny_status"
        # Check if the conditions are met
        if [[ "$cron_deny_status" == *"Access: (640/-rw-r-----) Owner: (root) Group: (root)"* ]]; then
            echo "/etc/cron.deny permissions and ownership are correctly set."
        else
            echo "/etc/cron.deny permissions or ownership are not correctly set."
            exit 1
        fi
    else
        echo "/etc/cron.deny does not exist or is correctly configured."
    fi
else
    echo "cron is not installed"
fi

