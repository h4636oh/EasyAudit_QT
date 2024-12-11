#!/usr/bin/env bash

# Check if cron is installed
if command -v crontab >/dev/null 2>&1; then
    echo "cron is installed"

    # Create /etc/cron.allow if it doesn't exist, and set ownership and permissions
    if [ ! -e "/etc/cron.allow" ]; then
        touch /etc/cron.allow
        echo "/etc/cron.allow created"
    fi
    chown root:root /etc/cron.allow
    sudo chmod u-x,g-wx,o-rwx /etc/cron.allow
    echo "/etc/cron.allow ownership and permissions set"

    # If /etc/cron.deny exists, set ownership and permissions
    if [ -e "/etc/cron.deny" ]; then
        sudo chown root:root /etc/cron.deny
        sudo chmod u-x,g-wx,o-rwx /etc/cron.deny
        echo "/etc/cron.deny ownership and permissions set"
    else
        echo "/etc/cron.deny does not exist"
    fi
else
    echo "cron is not installed"
fi

