#!/bin/bash

# Function to output status and exit
audit_result() {
    local message=$1
    local exit_code=$2
    echo "$message"
    exit $exit_code
}

# Audit: Check SELinux policy configuration
check_selinux_policy() {
    # Check SELINUXTYPE in /etc/selinux/config
    selinux_type_config=$(grep -E '^\s*SELINUXTYPE=(targeted|mls)\b' /etc/selinux/config)

    if [[ $selinux_type_config =~ SELINUXTYPE=(targeted|mls) ]]; then
        # Check currently loaded SELinux policy
        loaded_policy=$(sestatus | grep 'Loaded policy name' | awk '{print $4}')
        if [[ $loaded_policy == "targeted" || $loaded_policy == "mls" ]]; then
            audit_result "SELinux policy is correctly configured" 0
        else
            audit_result "FAILED: Loaded SELinux policy is not 'targeted' or 'mls'" 1
        fi
    else
        audit_result "FAILED: SELINUXTYPE in /etc/selinux/config is not 'targeted' or 'mls'" 1
    fi
}

# Run the SELinux policy check
check_selinux_policy

# This script checks if the SELinux policy is configured correctly by verifying both the configuration file and the currently loaded policy. If both are as expected, it reports success; otherwise, it indicates failure and the script exits with code 1. 

# - The pattern in the `grep` command ensures that lines with `SELINUXTYPE` set to either `targeted` or `mls` are recognized.
# - Assumptions are made that `grep`, `sestatus`, and `awk` are available on the system where the script is run.
# - The script outputs the results and exits accordingly based on the checks.