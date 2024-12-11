#!/bin/bash

# This script audits if the kernel parameter net.ipv4.icmp_ignore_bogus_error_responses is set to 1

# The parameter should be loaded from an included file
# Assumptions:
# 1. Audit passes if the parameter is set in the running configuration and in any configuration file correctly.
# 2. Audit fails if the parameter is not set correctly in either the running configuration or in configuration files.

# Function to check the parameter in the running configuration
check_running_configuration() {
    local kpname=$1
    local kpvalue=$2
    local current_value

    current_value=$(sysctl "$kpname" 2>/dev/null | awk -F= '{print $2}' | xargs)
    if [ "$current_value" = "$kpvalue" ]; then
        return 0
    else
        return 1
    fi
}

# Function to check the parameter in configuration files
check_configuration_files() {
    local kpname=$1
    local kpvalue=$2

    # Get all files where the parameters might be set
    local config_files
    mapfile -t config_files < <(find /etc/sysctl.d/ -type f -name '*.conf' -exec grep -l "^\\s*$kpname\\s*=" {} +)

    # Also check /etc/sysctl.conf
    if grep -q "^\\s*$kpname\\s*=" /etc/sysctl.conf; then
        config_files+=("/etc/sysctl.conf")
    fi
    
    # If Uncomplicated Firewall is using its own file, check it as well
    if [ -f /etc/default/ufw ]; then
        local ufw_file=$(awk -F= '/^\\s*IPT_SYSCTL=/ {gsub(/"/, "", $2); print $2}' /etc/default/ufw)
        if grep -q "^\\s*$kpname\\s*=" "$ufw_file"; then
            config_files+=("$ufw_file")
        fi
    fi

    # Iterate through identified files
    for file in "${config_files[@]}"; do
        if grep -q "^\\s*$kpname\\s*=\\s*$kpvalue\\b" "$file"; then
            return 0
        fi
    done

    return 1
}

# Main audit execution
kpname="net.ipv4.icmp_ignore_bogus_error_responses"
kpvalue="1"

# Check running configuration
check_running_configuration "$kpname" "$kpvalue"
check_running_result=$?

# Check configuration files
check_configuration_files "$kpname" "$kpvalue"
check_files_result=$?

# Evaluate the audit results
if [ $check_running_result -eq 0 ] && [ $check_files_result -eq 0 ]; then
    echo "- Audit Result: ** PASS **"
    echo "  - \"$kpname\" is correctly set to \"$kpvalue\" in the running configuration and in configuration files."
    exit 0
else
    echo "- Audit Result: ** FAIL **"
    if [ $check_running_result -ne 0 ]; then
        echo "  - \"$kpname\" is incorrectly set or absent in the running configuration."
    else
        echo "  - \"$kpname\" is correctly set in the running configuration."
    fi
    if [ $check_files_result -ne 0 ]; then
        echo "  - \"$kpname\" is incorrectly set or absent in the configuration files."
    else
        echo "  - \"$kpname\" is correctly set in the configuration files."
    fi
    echo "Please ensure \"$kpname\" is set to \"$kpvalue\" in the running configuration and relevant configuration files."
    exit 1
fi
