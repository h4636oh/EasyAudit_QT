#!/usr/bin/env bash

# Run the command to check the audit rules for -e 2
output=$(grep -Ph -- '^\h*-e\h+2\b' /etc/audit/rules.d/*.rules | tail -1)

# Verify the output
if [[ "$output" == "-e 2" ]]; then
    echo "OK: Output matches expected value."
else
    echo "Warning: Output does not match expected value."
    echo "Output: $output"
    exit 1
fi

