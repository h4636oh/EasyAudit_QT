#!/bin/bash

# Check if cron is installed
if command -v crontab >/dev/null 2>&1; then
    echo "cron is installed"

    # Set ownership to root:root
    sudo chown root:root /etc/cron.daily/
    echo "Ownership set to root:root for /etc/cron.daily"

    # Set permissions to remove read, write, and execute permissions for group and others
    sudo chmod og-rwx /etc/cron.daily/
    echo "Permissions set to 700 for /etc/cron.daily"
else
    echo "cron is not installed"
fi

