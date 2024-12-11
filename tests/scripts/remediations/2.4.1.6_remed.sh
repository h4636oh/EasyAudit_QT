#!/bin/bash

# Check if cron is installed
if command -v crontab >/dev/null 2>&1; then
    echo "cron is installed"

    # Set ownership to root:root
    chown root:root /etc/cron.monthly/
    sudo echo "Ownership set to root:root for /etc/cron.monthly"

    # Set permissions to remove read, write, and execute permissions for group and others
    sudo chmod og-rwx /etc/cron.monthly/
    echo "Permissions set to 700 for /etc/cron.monthly"
else
    echo "cron is not installed"
fi

