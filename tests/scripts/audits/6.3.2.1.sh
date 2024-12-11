#!/bin/bash

# Run the command to check the max_log_file parameter
result=$(grep -Po -- '^\h*max_log_file\h*=\h*\d+\b' /etc/audit/auditd.conf)

# Check if the output is empty or not
if [ -n "$result" ]; then
    echo "Current max_log_file setting: $result"
else
    echo "The max_log_file parameter is not set in /etc/audit/auditd.conf."
    exit 1
fi

