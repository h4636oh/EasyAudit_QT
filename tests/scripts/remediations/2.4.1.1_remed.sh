#!/bin/bash

# Check if cron is installed
if command -v crontab >/dev/null 2>&1; then
    echo "cron is installed"

    # Unmask cron
    systemctl unmask "$(systemctl list-unit-files | awk '$1~/^crond?\.service/{print $1}')"
    echo "cron unmasked"

    # Enable and start cron
    systemctl --now enable "$(systemctl list-unit-files | awk '$1~/^crond?\.service/{print $1}')"
    echo "cron enabled and started"
else
    echo "cron is not installed"
fi

