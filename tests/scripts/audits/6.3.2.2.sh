#!/bin/bash

# Run the command to check the max_log_file_action parameter
result=$(grep 'max_log_file_action' /etc/audit/auditd.conf)

# Check if the output matches the expected value
if [ "$result" == "max_log_file_action = keep_logs" ]; then
    echo "The max_log_file_action parameter is correctly set to 'keep_logs'."
else
    echo "The max_log_file_action parameter does not match the expected value. Current setting:"
    echo "$result"
    exit 1
fi

