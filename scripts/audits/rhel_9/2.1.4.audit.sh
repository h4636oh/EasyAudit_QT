#!/bin/bash

# Script to audit DNS server services
# Ensure the script adheres to Bash syntax and best practices.
# Exits with status 1 if audit fails and 0 if audit passes.

# Function to check if bind is not installed
check_bind_not_installed() {
    if rpm -q bind &>/dev/null; then
        echo "[FAIL] The 'bind' package is installed."
        return 1
    else
        echo "[PASS] The 'bind' package is not installed."
        return 0
    fi
}

# Function to check if named.service is disabled and inactive
check_named_service() {
    local enabled_status=$(systemctl is-enabled named.service 2>/dev/null)
    local active_status=$(systemctl is-active named.service 2>/dev/null)

    if [[ "$enabled_status" == "enabled" ]]; then
        echo "[FAIL] The 'named.service' is enabled."
        return 1
    fi

    if [[ "$active_status" == "active" ]]; then
        echo "[FAIL] The 'named.service' is active."
        return 1
    fi

    echo "[PASS] The 'named.service' is neither enabled nor active."
    return 0
}

# Main audit logic
if check_bind_not_installed; then
    exit 0
elif check_named_service; then
    echo "[INFO] 'bind' package is installed due to dependencies."
    echo "       Ensure dependent packages are approved by local site policy."
    echo "       Review if stopping and masking the service meets local site policy."
    exit 0
else
    echo "[FAIL] Audit failed. Manual intervention required."
    exit 1
fi

# This script audits the system to ensure that the `bind` package is not installed or that the `named.service` is not enabled and not active if it is installed due to dependencies. The script exits with a status of 1 if any check fails, indicating the system does not meet the audit requirements. If the `bind` package is indeed installed, it advises manual verification to ensure compliance with local site policies.