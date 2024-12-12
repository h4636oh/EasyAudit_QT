#!/bin/bash

# Script to audit the configuration for monitoring the use of the mount system call.
# This script checks both on-disk configurations and loaded rules as per specified criteria.

# Function to check on-disk audit rules
audit_on_disk_config() {
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -z "${UID_MIN}" ]; then
        echo "ERROR: Variable 'UID_MIN' is unset."
        exit 1
    fi

    # Check on-disk rules
    matches=$(awk "/^ *-a *always,exit/ &&/ -F *arch=b(32|64)/ &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) &&/ -F *auid>=${UID_MIN}/ &&/ -S/ &&/mount/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/" /etc/audit/rules.d/*.rules)

    if [[ $matches =~ "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=unset -k mounts" && $matches =~ "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=unset -k mounts" ]]; then
        echo "On-disk configuration matches expected rules."
    else
        echo "Error: On-disk configuration does not match expected rules."
        exit 1
    fi
}

# Function to check loaded audit rules
audit_running_config() {
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -z "${UID_MIN}" ]; then
        echo "ERROR: Variable 'UID_MIN' is unset."
        exit 1
    fi

    # Check loaded rules
    matches=$(auditctl -l | awk "/^ *-a *always,exit/ &&/ -F *arch=b(32|64)/ &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) &&/ -F *auid>=${UID_MIN}/ &&/ -S/ &&/mount/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/")

    if [[ $matches =~ "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=-1 -F key=mounts" && $matches =~ "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=-1 -F key=mounts" ]]; then
        echo "Running configuration matches expected rules."
    else
        echo "Error: Running configuration does not match expected rules."
        exit 1
    fi
}

# Run both audits
audit_on_disk_config
audit_running_config

# If the script has not exited by this point, audits are successful
exit 0

# This script performs the checks described in your input. It verifies both the on-disk configuration and the loaded audit rules to ensure they capture successful file system mounts by non-privileged users. If any configuration does not meet expectations, it exits with a code of 1.