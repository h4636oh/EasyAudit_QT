#!/bin/bash

# Audit script to check if successful and unsuccessful attempts to use the setfacl command are being logged
# This does NOT remediate, only audits
# Exit 0 on success, or exit 1 on failure

# Get UID_MIN from /etc/login.defs
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

# Check if UID_MIN is set
if [ -z "${UID_MIN}" ]; then
    echo "ERROR: Variable 'UID_MIN' is unset."
    exit 1
fi

# Function to audit on-disk rules
audit_disk_rules() {
    echo "Checking on-disk rules..."

    EXPECTED_RULE="-a always,exit -F path=/usr/bin/setfacl -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng"
    ON_DISK_RULES=$(awk "/^ *-a *always,exit/ \
        &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
        &&/ -F *auid>=${UID_MIN}/ \
        &&/ -F *perm=x/ \
        &&/ -F *path=\\/usr\\/bin\\/setfacl/ \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

    if [[ "${ON_DISK_RULES}" != *"${EXPECTED_RULE}"* ]]; then
        echo "ERROR: On-disk audit rules do not match expected configuration."
        return 1
    fi

    return 0
}

# Function to audit running configuration
audit_running_config() {
    echo "Checking running (loaded) rules..."

    EXPECTED_RULE_LOADED="-a always,exit -S all -F path=/usr/bin/setfacl -F perm=x -F auid>=${UID_MIN} -F auid!=-1 -F key=perm_chng"
    RUNNING_RULES=$(auditctl -l | awk "/^ *-a *always,exit/ \
        &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
        &&/ -F *auid>=${UID_MIN}/ \
        &&/ -F *perm=x/ \
        &&/ -F *path=\\/usr\\/bin\\/setfacl/ \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)")

    if [[ "${RUNNING_RULES}" != *"${EXPECTED_RULE_LOADED}"* ]]; then
        echo "ERROR: Running (loaded) audit rules do not match expected configuration."
        return 1
    fi

    return 0
}

# Perform audits
audit_disk_rules
DISK_RULE_RESULT=$?

audit_running_config
RUNNING_RULE_RESULT=$?

# Exit based on audit results
if [ ${DISK_RULE_RESULT} -eq 0 ] && [ ${RUNNING_RULE_RESULT} -eq 0 ]; then
    echo "Audit passed: Both on-disk and running configurations are correct."
    exit 0
else
    echo "Audit failed: Please review the error messages above."
    exit 1
fi
