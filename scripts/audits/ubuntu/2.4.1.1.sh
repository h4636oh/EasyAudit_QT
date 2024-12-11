#!/bin/bash

# Check if cron is installed
if command -v crontab >/dev/null 2>&1; then
    echo "cron is installed"
else
    echo "cron is not installed"
    exit 0
fi

# Verify if cron is enabled
enabled_status=$(systemctl list-unit-files | awk '$1~/^crond?\.service/{print $2}')
if [[ $enabled_status == "enabled" ]]; then
    echo "cron is enabled"
else
    echo "cron is not enabled"
    exit 1
fi

# Verify if cron is active
active_status=$(systemctl list-units | awk '$1~/^crond?\.service/{print $3}')
if [[ $active_status == "active" ]]; then
    echo "cron is active"
else
    echo "cron is not active"
    exit 1
fi

