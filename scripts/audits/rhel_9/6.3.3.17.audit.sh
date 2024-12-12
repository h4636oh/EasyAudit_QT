#!/bin/bash

# Script to audit whether the system generates audit records for successful/unsuccessful 
# uses of the chacl command.

# Function to check the audit rules
check_audit_rules() {
    local mode=$1
    local cmd=$2
    local output_match="
-a always,exit -F path=/usr/bin/chacl -F perm=x -F auid>=1000 -F auid!=unset -k perm_chng
"
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    
    if [ -z "$UID_MIN" ]; then
        echo "ERROR: Variable 'UID_MIN' is unset."
        return 1
    fi

    # Execute the provided command and capture its output
    RULE_OUTPUT=$(eval "$cmd")
    
    if [[ "$RULE_OUTPUT" == *"$output_match"* ]]; then
        return 0
    else
        echo "The audit rules for $mode do not match the required configuration."
        return 1
    fi
}

# Audit 'on-disk' configuration
check_audit_rules "on-disk" \
    "[ -n \"$UID_MIN\" ] && awk \"/^ *-a *always,exit/ && (/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) &&/ -F *auid>=$UID_MIN/ &&/ -F *perm=x/ &&/ -F *path=\\/usr\\/bin\\/chacl/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)\" /etc/audit/rules.d/*.rules" 

on_disk_check=$?

# Audit 'running' configuration
check_audit_rules "running" \
    "[ -n \"$UID_MIN\" ] && auditctl -l | awk \"/^ *-a *always,exit/ && (/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) &&/ -F *auid>=$UID_MIN/ &&/ -F *perm=x/ &&/ -F *path=\\/usr\\/bin\\/chacl/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)\""

running_check=$?

# Evaluate the results and exit accordingly
if [ $on_disk_check -eq 0 ] && [ $running_check -eq 0 ]; then
    echo "Audit success: The chacl command audit configuration is correct."
    exit 0
else
    echo "Audit failure: The chacl command audit configuration is incorrect."
    exit 1
fi

# ### Explanation:
# - This script audits the system to ensure that it generates audit records for the `chacl` command.
# - It checks both the `on-disk` and `running` configurations by using `awk` and `auditctl`.
# - If both checks pass, the script exits with `0`, indicating success. Otherwise, it exits with `1`, indicating failure.
# - The `UID_MIN` variable is fetched from `/etc/login.defs` to ensure user threshold.
# - The `output_match` string specifies the expected audit rule.
# - Error handling is incorporated to manage cases where `UID_MIN` is unset.