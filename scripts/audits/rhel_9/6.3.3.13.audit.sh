#!/bin/bash

# Function to check disk configuration audit rules
check_disk_configuration() {
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -z "${UID_MIN}" ]; then
        echo "ERROR: Variable 'UID_MIN' is unset."
        return 1
    fi

    local expected_rule_1="-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -F auid>=${UID_MIN} -F auid!=unset -k delete"
    local expected_rule_2="-a always,exit -F arch=b32 -S unlink,unlinkat,rename,renameat -F auid>=${UID_MIN} -F auid!=unset -k delete"

    local matches=$(awk "/^ *-a *always,exit/ \
        &&/ -F *arch=b(32|64)/ \
        &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
        &&/ -F *auid>=${UID_MIN}/ \
        &&/ -S/ \
        &&(/unlink/||/rename/||/unlinkat/||/renameat/) \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/" /etc/audit/rules.d/*.rules)

    if [[ "${matches}" != *"${expected_rule_1}"* ]] || [[ "${matches}" != *"${expected_rule_2}"* ]]; then
        echo "Disk configuration audit rules do not match the expected rules."
        return 1
    fi

    return 0
}

# Function to check running configuration audit rules
check_running_configuration() {
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -z "${UID_MIN}" ]; then
        echo "ERROR: Variable 'UID_MIN' is unset."
        return 1
    fi

    local expected_rule_1="-a always,exit -F arch=b64 -S rename,unlink,unlinkat,renameat -F auid>=${UID_MIN} -F auid!=-1 -F key=delete"
    local expected_rule_2="-a always,exit -F arch=b32 -S unlink,rename,unlinkat,renameat -F auid>=${UID_MIN} -F auid!=-1 -F key=delete"

    local matches=$(auditctl -l | awk "/^ *-a *always,exit/ \
        &&/ -F *arch=b(32|64)/ \
        &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
        &&/ -F *auid>=${UID_MIN}/ \
        &&/ -S/ \
        &&(/unlink/||/rename/||/unlinkat/||/renameat/) \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/")

    if [[ "${matches}" != *"${expected_rule_1}"* ]] || [[ "${matches}" != *"${expected_rule_2}"* ]]; then
        echo "Running configuration audit rules do not match the expected rules."
        return 1
    fi

    return 0
}

main() {
    check_disk_configuration && check_running_configuration
    if [ $? -eq 0 ]; then
        echo "Audit passed: File deletion events by users are properly collected."
        exit 0
    else
        echo "Audit failed: Please review the audit rules."
        exit 1
    fi
}

main
