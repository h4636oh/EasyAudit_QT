#!/usr/bin/env bash

# Configure the audit log directory to have a mode of "0750" or less permissive
if [ -f /etc/audit/auditd.conf ]; then
    log_dir=$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' /etc/audit/auditd.conf | xargs)")
    sudo chmod g-w,o-rwx "$log_dir"
    echo "Permissions for audit log directory $log_dir have been set to 0750 or less permissive"
else
    echo "Audit configuration file /etc/audit/auditd.conf not found."
    exit 1
fi

