#!/bin/bash

# Script to audit session initiation information collection
# This checks if audit rules are correctly set for monitoring utmp, wtmp, and btmp files.

# Expected configuration
expected_rules=(
    "-w /var/run/utmp -p wa -k session"
    "-w /var/log/wtmp -p wa -k session"
    "-w /var/log/btmp -p wa -k session"
)

# Function to check rules in audit files
check_audit_file_rules() {
    for rule in "${expected_rules[@]}"; do
        if ! awk "/^ *-w/ && ($rule| -k session)" /etc/audit/rules.d/*.rules &> /dev/null; then
            echo "Audit file configuration mismatch: $rule not found"
            return 1
        fi
    done
    echo "Audit file configuration matches expected rules."
}

# Function to check loaded rules
check_loaded_audit_rules() {
    for rule in "${expected_rules[@]}"; do
        if ! auditctl -l | awk "/^ *-w/ && ($rule| -k session)" &> /dev/null; then
            echo "Running configuration mismatch: $rule not found"
            return 1
        fi
    done
    echo "Running configuration matches expected rules."
}

# Run checks
check_audit_file_rules
audit_file_status=$?

check_loaded_audit_rules
loaded_audit_status=$?

# Determine script result based on audit checks
if [ $audit_file_status -eq 0 ] && [ $loaded_audit_status -eq 0 ]; then
    echo "Audit checks passed. Session initiation information is being collected correctly."
    exit 0
else
    echo "Audit checks failed. Please ensure audit rules are properly configured."
    exit 1
fi

# This Bash script ensures that session initiation information is being audited correctly by verifying the presence of the necessary auditing rules both in the audit configuration files and in the currently loaded audit rules. The script checks against the expected rules for monitoring `utmp`, `wtmp`, and `btmp` files.

# - If both checks pass, the script exits with a status of 0.
# - If any check fails, it exits with a status of 1 and provides an informative message.