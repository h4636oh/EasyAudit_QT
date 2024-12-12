#!/bin/bash

# Script to audit if successful and unsuccessful uses of the usermod command are collected
# This script checks both the on-disk and running audit rules configurations.

# Get the minimum user ID for non-system accounts
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

# Check if UID_MIN is set
if [ -z "${UID_MIN}" ]; then
    echo "ERROR: Variable 'UID_MIN' is unset."
    exit 1
fi

# Define the expected audit rule for usermod
expected_rule="-a always,exit -F path=/usr/sbin/usermod -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k usermod"

# Audit on-disk rules
echo "Checking on-disk audit rules for usermod command..."
disk_audit_output=$(awk "/^-a always,exit/ && /-F path=\\/usr\\/sbin\\/usermod/ && /-F perm=x/ && /-F auid>=${UID_MIN}/ && /-F auid!=unset/" /etc/audit/rules.d/*.rules)

if [[ "${disk_audit_output}" == *"${expected_rule}"* ]]; then
    echo "On-disk audit rules are correctly configured."
else
    echo "On-disk audit rules for usermod command are not configured correctly."
    exit 1
fi

# Audit running configuration
echo "Checking loaded audit rules for usermod command..."
running_audit_output=$(auditctl -l | awk "/^-a always,exit/ && /-F path=\\/usr\\/sbin\\/usermod/ && /-F perm=x/ && /-F auid>=${UID_MIN}/ && /-F auid!=unset/")

if [[ "${running_audit_output}" == *"${expected_rule}"* ]]; then
    echo "Running audit rules are correctly configured."
else
    echo "Running audit rules for usermod command are not configured correctly."
    exit 1
fi

# If both checks pass, exit successfully
exit 0