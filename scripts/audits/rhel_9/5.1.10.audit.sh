#!/bin/bash

# Title: Ensure sshd DisableForwarding is enabled (Automated)

# This script audits whether the DisableForwarding option is set correctly in the SSH server configuration.
# It should be set to 'yes' to disallow all types of forwarding for improved security.

# Command to audit DisableForwarding setting
AUDIT_COMMAND="sshd -T | grep -i disableforwarding"

# Expected result for the audit command
EXPECTED_RESULT="disableforwarding yes"

# Perform the audit and capture the output
ACTUAL_RESULT=$($AUDIT_COMMAND 2>&1)

# Check if the observed configuration matches the expected configuration
if [[ "$ACTUAL_RESULT" == "$EXPECTED_RESULT" ]]; then
    echo "Audit passed: DisableForwarding is correctly set to 'yes'."
    exit 0
else
    echo "Audit failed: DisableForwarding is not set correctly."
    echo "Please ensure the following line is present in your /etc/ssh/sshd_config file, above any Include directives:"
    echo ""
    echo "DisableForwarding yes"
    exit 1
fi
