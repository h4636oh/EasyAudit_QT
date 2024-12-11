#!/bin/bash

# This script audits the kernel parameters for reverse path filtering.
# Specifically, it checks if net.ipv4.conf.all.rp_filter and net.ipv4.conf.default.rp_filter are set to 1.
# Exits with status code 0 if compliant, 1 if not compliant.

# Variables
declare -A expected_params
expected_params=(
    ["net.ipv4.conf.all.rp_filter"]="1"
    ["net.ipv4.conf.default.rp_filter"]="1"
)

# Audit function to check each parameter
audit_kernel_parameter() {
    local param_name="$1"
    local expected_value="$2"

    # Check current value in the running configuration
    current_value=$(sysctl -n "$param_name" 2>/dev/null)

    if [ "$current_value" == "$expected_value" ]; then
        echo "- \"$param_name\" is correctly set to \"$expected_value\" in the running configuration"
        return 0
    else
        echo "- \"$param_name\" is incorrectly set to \"$current_value\" in the running configuration, should be \"$expected_value\""
        return 1
    fi
}

# Main audit process
audit_status=0

echo "Starting the audit of kernel parameters for reverse path filtering..."

for param in "${!expected_params[@]}"; do
    audit_kernel_parameter "$param" "${expected_params[$param]}"
    audit_status=$((audit_status + $?))
done

if [ "$audit_status" -eq 0 ]; then
    echo -e "\n- Audit Result:\n ** PASS **"
    exit 0
else
    echo -e "\n- Audit Result:\n ** FAIL **"
    exit 1
fi
