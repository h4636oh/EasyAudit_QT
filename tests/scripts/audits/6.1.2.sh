#!/bin/bash

# Function to check cron jobs for AIDE
check_cron_jobs() {
    echo "Checking cron jobs for AIDE..."
    grep -Prs '^([^#\n\r]+\h+)?(\/usr\/s?bin\/|^\h*)aide(\.wrapper)?\h+(--(check|update)|([^#\n\r]+\h+)?\$AIDEARGS)\b' /etc/cron.* /etc/crontab /var/spool/cron/
}

# Function to check systemd services and timers for AIDE
check_systemd_services() {
    echo "Checking systemd services and timers for AIDE..."
    systemctl is-enabled aidecheck.service
    systemctl is-enabled aidecheck.timer
    systemctl status aidecheck.timer
}

# Execute the functions
check_cron_jobs
check_systemd_services

