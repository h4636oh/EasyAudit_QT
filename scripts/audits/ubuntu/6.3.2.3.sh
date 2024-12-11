#!/bin/bash

# Verify the disk_full_action parameter is set to either halt or single
disk_full_action_result=$(grep -Pi -- '^\h*disk_full_action\h*=\h*(halt|single)\b' /etc/audit/auditd.conf)

if [ -n "$disk_full_action_result" ]; then
    echo "disk_full_action is set correctly: $disk_full_action_result"
else
    echo "disk_full_action is not set to halt or single."
    exit 1
fi

# Verify the disk_error_action parameter is set to syslog, single, or halt
disk_error_action_result=$(grep -Pi -- '^\h*disk_error_action\h*=\h*(syslog|single|halt)\b' /etc/audit/auditd.conf)

if [ -n "$disk_error_action_result" ]; then
    echo "disk_error_action is set correctly: $disk_error_action_result"
else
    echo "disk_error_action is not set to syslog, single, or halt."
    exit 1
fi

