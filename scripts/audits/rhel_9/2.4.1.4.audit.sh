#!/bin/bash

# Script to audit permissions and ownership of /etc/cron.daily
# Exit 0 if permissions and ownership are correct (passes audit)
# Exit 1 if permissions and ownership are incorrect (fails audit)

# Check if cron is installed
if ! command -v crontab &> /dev/null; then
    echo "Cron is not installed on the system."
    # Since cron is not installed, auditing the directory does not apply
    exit 0
fi

# Define the directory to check
CRON_DAILY_DIR="/etc/cron.daily"

# Check the permissions and ownership of the directory
output=$(stat -Lc "Access: (%a/%A) Uid: (%u/%U) Gid: (%g/%G)" "$CRON_DAILY_DIR")

# Parse the output
permissions=$(echo "$output" | awk '{print $2}' | tr -d '()')
uid=$(echo "$output" | awk '{print $4}' | tr -d '()')
gid=$(echo "$output" | awk '{print $6}' | tr -d '()')

# Verify that permissions and ownership meet the requirements
if [[ "$permissions" == "700/drwx------" && "$uid" == "0/root" && "$gid" == "0/root" ]]; then
    echo "Audit passed: $CRON_DAILY_DIR has correct permissions and ownership."
    exit 0
else
    echo "Audit failed: $CRON_DAILY_DIR has incorrect permissions or ownership."
    echo "Current status: $output"
    echo "Please manually correct the permissions and ownership."
    echo "Refer to remediation instructions to correct the issues."
    exit 1
fi
