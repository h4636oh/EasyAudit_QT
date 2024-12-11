#!/bin/bash

# Audit script for monitoring user emulation in audit rules

# Determine system architecture
arch=$(uname -m)

# On-disk configuration check
on_disk_check=$(awk '/^ *-a *always,exit/ \
&&/ -F *arch=b(32|64)/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&(/ -C *euid!=uid/||/ -C *uid!=euid/) \
&&/ -S *execve/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

# Running configuration check
running_config_check=$(auditctl -l | awk '/^ *-a *always,exit/ \
&&/ -F *arch=b(32|64)/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&(/ -C *euid!=uid/||/ -C *uid!=euid/) \
&&/ -S *execve/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)')

# Architecture-specific expected rules
if [[ "$arch" == "x86_64" ]]; then
    expected_rules="-a always,exit -F arch=b64 -S execve -C uid!=euid -F auid!=-1 -F key=user_emulation
-a always,exit -F arch=b32 -S execve -C uid!=euid -F auid!=-1 -F key=user_emulation"
elif [[ "$arch" == "i686" || "$arch" == "i386" ]]; then
    expected_rules="-a always,exit -F arch=b32 -S execve -C uid!=euid -F auid!=-1 -F key=user_emulation"
else
    echo "Unsupported architecture"
    exit 1
fi

# Perform verification
verify_rules() {
    local check_type="$1"
    local rules="$2"

    if [[ -z "$rules" ]]; then
        echo "No $check_type rules found"
        return 1
    fi

    if [[ "$rules" != "$expected_rules" ]]; then
        echo "$check_type rules do not match expected configuration"
        echo "Current $check_type rules:"
        echo "$rules"
        echo "Expected rules:"
        echo "$expected_rules"
        return 1
    fi

    return 0
}

# Check on-disk rules
verify_rules "on-disk" "$on_disk_check" || exit_status=1

# Check running configuration rules
verify_rules "running" "$running_config_check" || exit_status=1

# Exit with appropriate status
if [[ -n "$exit_status" ]]; then
    echo "Audit failed: User emulation audit rules are not correctly configured"
    exit 1
fi

echo "Audit passed: User emulation audit rules are correctly configured"
exit 0