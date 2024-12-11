#!/bin/bash

# Check if cron is installed
if command -v crontab >/dev/null 2>&1; then
    echo "cron is installed"

    # Verify Uid and Gid are both 0/root and Access does not grant permissions to group or other
    stat_output=$(stat -Lc 'Access: (%a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/cron.weekly/)
    echo "$stat_output"

    # Check if the conditions are met
    if [[ "$stat_output" == *"Access: (700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then
        echo "Permissions and ownership are correctly set."
    else
        echo "Permissions or ownership are not correctly set."
        exit 1
    fi
else
    echo "cron is not installed"
fi

