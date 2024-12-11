#!/bin/bash

# Script to audit if filesystem integrity checks are scheduled via cron or systemd

# Function to check if a pattern exists in crontab or cron directories
check_cronjob() {
    grep -Ers '^([^#]+\s+)?(\/usr\/s?bin\/|^\s*)aide(\.wrapper)?\s(--?\S+\s)*(--(check|update)|\$AIDEARGS)\b' /etc/cron.* /etc/crontab /var/spool/cron/ > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        # Cronjob is present
        return 0
    else
        # Cronjob is absent
        return 1
    fi
}

# Function to check if systemd services are enabled and running
check_systemd() {
    # Check if aidecheck.service is enabled
    systemctl is-enabled aidecheck.service > /dev/null 2>&1
    service_enabled=$?

    # Check if aidecheck.timer is enabled
    systemctl is-enabled aidecheck.timer > /dev/null 2>&1
    timer_enabled=$?

    # Check if aidecheck.timer is active
    systemctl is-active aidecheck.timer > /dev/null 2>&1
    timer_active=$?

    if [ $service_enabled -eq 0 ] && [ $timer_enabled -eq 0 ] && [ $timer_active -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# Main function to assess the compliance
audit_check() {
    check_cronjob
    cron_status=$?

    check_systemd
    systemd_status=$?

    if [ $cron_status -eq 0 ] || [ $systemd_status -eq 0 ]; then
        echo "Filesystem integrity check is scheduled correctly."
        exit 0
    else
        echo "Filesystem integrity check is NOT scheduled! Please set it manually as per site policy."
        exit 1
    fi
}

# Run the audit check
audit_check
```

### Key Points:
- The script checks for the existence of an `aide` cron job as well as checks if necessary systemd units (`aidecheck.service` and `aidecheck.timer`) are enabled and active.
- If the cron job is found or the systemd services are correctly enabled and running, it will output success and exit with `0`.
- If neither method is set up, it outputs a warning message and exits with `1`.