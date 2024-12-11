#!/bin/bash

# Check if cron is installed
if command -v crontab >/dev/null 2>&1; then
    echo "cron is installed"

    # Set ownership to root:root
    sudo chown root:root /etc/crontab
    echo "Ownership set to root:root"

    # Set permissions to remove read, write, and execute permissions for group and others
    sudo chmod og-rwx /etc/crontab
    echo "Permissions set to 600"
else
    echo "cron is not installed"
fi

