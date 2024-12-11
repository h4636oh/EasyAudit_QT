#!/bin/bash

# Description:
# This script audits the system configuration to ensure that source routed packets are not accepted.
# The respective kernel parameters for both IPv4 and IPv6 must be set to 0.

# Parameters to check
declare -A PARAMETERS=(
    ["net.ipv4.conf.all.accept_source_route"]="0"
    ["net.ipv4.conf.default.accept_source_route"]="0"
    ["net.ipv6.conf.all.accept_source_route"]="0"
    ["net.ipv6.conf.default.accept_source_route"]="0"
)

# Function to check if IPv6 is enabled
is_ipv6_enabled() {
    sysctl net.ipv6.conf.all.disable_ipv6 | grep -Pqs -- "net\\.ipv6\\.conf\\.all\\.disable_ipv6\\s*=\\s*0\\b" && return 0 || return 1
}

# Audit function for each parameter
audit_parameter() {
    local param_name="$1"
    local expected_value="$2"
    local actual_value

    actual_value=$(sysctl "$param_name" 2>/dev/null | awk -F= '{print $2}' | xargs)
    if [ "$actual_value" != "$expected_value" ]; then
        echo "- $param_name is incorrectly set to $actual_value, should be $expected_value"
        return 1
    fi
    echo "- $param_name is correctly set to $actual_value"
    return 0
}

# Main audit process
main_audit() {
    local any_failure=0

    for param_name in "${!PARAMETERS[@]}"; do
        # Skip IPv6 checks if IPv6 is disabled
        if [[ $param_name =~ ^net\.ipv6\. ]] && ! is_ipv6_enabled; then
            echo "- $param_name is not applicable as IPv6 is disabled"
            continue
        fi
        
        if ! audit_parameter "$param_name" "${PARAMETERS[$param_name]}"; then
            any_failure=1
        fi
    done

    if [ $any_failure -eq 1 ]; then
        echo "** FAIL **: One or more parameters are not correctly set."
        exit 1
    else
        echo "** PASS **: All parameters are correctly set."
        exit 0
    fi
}

# Execute the main audit function
main_audit