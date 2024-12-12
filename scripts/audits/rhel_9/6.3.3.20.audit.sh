#!/bin/bash

# Audit script to verify if the audit system is set to immutable using "-e 2"

# Command to check the audit rules for immutable settings
audit_check_output=$(grep -Ph -- '^\h*-e\h+2\b' /etc/audit/rules.d/*.rules | tail -1)

# Expected output
expected_output="-e 2"

# Verify that the output matches the expected immutable setting
if [[ "$audit_check_output" == *"$expected_output" ]]; then
    echo "Audit configuration is correctly set to immutable."
    exit 0
else
    echo "Audit configuration is NOT set to immutable."
    echo "Please ensure that the system audit rules file contains '-e 2' to set immutable mode."
    exit 1
fi

# Note:
# - The script checks if the audit rules contain the "-e 2" setting which ensures that the audit configuration is immutable.
# - It uses grep to check for the presence of "-e 2" in the audit rules files.
# - It provides appropriate output and exit status based on whether the configuration matches the expected setting.
# - The script assumes no remediation, only auditing as per the requirements.