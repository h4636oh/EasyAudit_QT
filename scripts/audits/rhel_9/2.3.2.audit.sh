#!/bin/bash

# Script to audit chrony configuration for time synchronization

# Audit command
AUDIT_COMMAND="grep -Prs -- '^\h*(server|pool)\h+[^#\n\r]+' /etc/chrony.conf /etc/chrony.d/"

# Execute the audit command
OUTPUT=$($AUDIT_COMMAND)

# Check if the output contains any 'server' or 'pool' lines indicating remote servers are configured
if [[ -n $OUTPUT ]]; then
    echo "Audit passed: Remote server(s) are configured correctly."
    exit 0
else
    echo "Audit failed: Remote server(s) are not configured correctly."
    echo "Please ensure that chrony is configured correctly by adding 'server' or 'pool' lines to /etc/chrony.conf or files in /etc/chrony.d."
    exit 1
fi

# Comments:
# - This script audits the `chrony` configuration to ensure that at least one remote server is configured in either `/etc/chrony.conf` or `/etc/chrony.d/`.
# - It uses `grep` to check for valid `server` or `pool` lines that do not start with comments.
# - If such lines are found, the audit passes and exits with `0`, otherwise, it informs the user about manual configuration needs and exits with `1`.
