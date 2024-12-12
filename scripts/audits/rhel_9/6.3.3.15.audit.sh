#!/bin/bash

# This script audits whether the operating system generates audit records for both successful and unsuccessful uses of the chcon command.

# Function to check if the required audit rule is set
audit_chcon_command() {
    local expected_rule="-a always,exit -F path=/usr/bin/chcon -F perm=x -F auid>=1000 -F auid!=-1 -F key=perm_chng"
    
    echo "Checking on-disk audit rules configuration..."
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -z "$UID_MIN" ]; then
        echo "ERROR: Variable 'UID_MIN' is unset."
        exit 1
    fi

    local on_disk_rule
    on_disk_rule=$(awk "/^ *-a *always,exit/ && / -F *auid!=unset/ && / -F *auid>=${UID_MIN}/ && / -F *perm=x/ && / -F *path=\/usr\/bin\/chcon/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

    if [ "$on_disk_rule" != "$expected_rule" ]; then
        echo "ERROR: On-disk rule does not match the expected configuration."
        echo "Expected: $expected_rule"
        exit 1
    fi

    echo "Checking loaded audit rules..."
    local loaded_rule
    loaded_rule=$(auditctl -l | awk "/^ *-a *always,exit/ && / -F *auid!=unset/ && / -F *auid>=${UID_MIN}/ && / -F *perm=x/ && / -F *path=\/usr\/bin\/chcon/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)")

    if [ "$loaded_rule" != "$expected_rule" ]; then
        echo "ERROR: Loaded rule does not match the expected configuration."
        echo "Expected: $expected_rule"
        exit 1
    fi

    echo "Audit configuration for chcon command is correct."
    exit 0
}

# Execute the audit function
audit_chcon_command

# Explanation:
# - The script defines a function `audit_chcon_command` that checks both the on-disk audit configuration and the loaded audit rules for the `chcon` command.
# - It uses `awk` to fetch and verify the required rules from both the on-disk files and the loaded rules using `auditctl`.
# - An error is displayed, and the script exits with a status of `1` if the requirements are not met. It exits with `0` if the audit passes.
# - Validates the presence of the `UID_MIN` variable from `/etc/login.defs` to ensure correct processing.
# - If `UID_MIN` is not set, it reports an error and exits.