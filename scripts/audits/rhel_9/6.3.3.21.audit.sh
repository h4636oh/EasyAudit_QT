#!/bin/bash

# Script to audit that all audit rules from /etc/audit/rules.d/ are merged into /etc/audit/audit.rules
# This script does not execute any remediation steps, it only checks the current state.
# Exits with status 0 if audit is successful; exits with status 1 if audit fails.

# Check if augenrules command exists
if ! command -v augenrules &> /dev/null; then
    echo "augenrules command not found. Please install audit package first."
    exit 1
fi

# Run the augenrules --check to verify if the rules are merged
check_output=$(augenrules --check 2>&1)

# Check the output for "No change" which indicates rules are properly merged
if echo "$check_output" | grep -q "No change"; then
    echo "Audit successful: All rules are properly merged into /etc/audit/audit.rules."
    exit 0
else
    echo "Audit failed: There may be drift in the rule sets."
    echo "Output from augenrules --check:"
    echo "$check_output"

    # Inform user of manual remediation steps
    echo "Please run 'augenrules --load' to merge and load all rules manually."
    echo "Verify if the auditing configuration is locked with 'auditctl -s'."
    echo "If locked (-e 2), a system reboot may be required to fully load rules."
    exit 1
fi
