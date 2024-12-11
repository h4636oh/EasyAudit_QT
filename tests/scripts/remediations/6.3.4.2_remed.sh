#!/usr/bin/env bash

# Check if the auditd configuration file exists and update ownership for audit log files
if [ -f /etc/audit/auditd.conf ]; then
    log_dir=$(dirname "$(awk -F "=" '/^\s*log_file/ {print $2}' /etc/audit/auditd.conf | xargs)")
    find "$log_dir" -type f ! -user root -exec chown root {} +
    echo "Ownership updated for audit log files in $log_dir"
else
    echo "Audit configuration file /etc/audit/auditd.conf not found."
fi

