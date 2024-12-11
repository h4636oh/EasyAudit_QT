#!/bin/bash

# Script to audit if journald Storage is configured to be persistent
# This script checks if the journald storage configuration is set to persistent,
# which is important for retaining logs between reboots.

# Command to verify that Storage is set to persistent
storage_check=$(systemd-analyze cat-config systemd/journald.conf systemd/journald.conf.d/* | grep -E "^Storage=persistent")

# Evaluate the command output
if [[ $storage_check == "Storage=persistent" ]]; then
    echo "Audit Passed: Journald storage is set to persistent."
    exit 0
else
    echo "Audit Failed: Journald storage is NOT set to persistent."
    echo "Manual Action: Please set 'Storage=persistent' in /etc/systemd/journald.conf or a file in /etc/systemd/journald.conf.d/."
    exit 1
fi


### Explanation:
# - This script checks if the journald storage is configured to be persistent by searching for `Storage=persistent` in the configuration files.
# - If the setting is found, the audit passes and the script exits with `0`.
# - If the setting is not found, the audit fails, a manual action message is printed to inform the user to set the configuration correctly, and the script exits with `1`.
# - Assumes that journald is used as the logging method as mentioned in the requirements. If rsyslog is used, this script should not apply.