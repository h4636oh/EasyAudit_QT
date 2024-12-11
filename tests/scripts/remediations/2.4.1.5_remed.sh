#!/bin/bash

# Check if cron is installed
if command -v crontab >/dev/null 2>&1; then
    echo "cron is installed"

    # Set ownership to root:root
    chown root:root /etc/cron.weekly/
    sudo echo "Ownership set to root:root for /etc/cron.weekly"

    # Set permissions to remove read, write, and execute permissions for group and others
    sudo chmod og-rwx /etc/cron.weekly/
    echo "Permissions set to 700 for /etc/cron.weekly"
else
    echo "cron is not installed"
fi

