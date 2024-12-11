#!/bin/bash

# Script to audit the disabling of packet redirect sending
# Ensure that the following kernel parameters are set correctly:
# - net.ipv4.conf.all.send_redirects is set to 0
# - net.ipv4.conf.default.send_redirects is set to 0

# Function to check the current kernel parameter and any configuration files
check_kernel_parameter() {
    local param_name=$1
    local expected_value=$2
    local current_value
    local config_files
    local file_value
    local audit_failed=0

    # Check the running configuration
    current_value=$(sysctl -n "$param_name")
    if [ "$current_value" != "$expected_value" ]; then
        echo " - $param_name is incorrectly set to $current_value in the running configuration. Expected: $expected_value."
        audit_failed=1
    else
        echo " - $param_name is correctly set to $expected_value in the running configuration."
    fi

    # Check the configuration files
    config_files=$(grep -R "^$param_name\s*=" /etc/sysctl.conf /etc/sysctl.d/* /etc/ufw/sysctl.conf 2>/dev/null)
    if [ -z "$config_files" ]; then
        echo " - $param_name is not set in any configuration file."
        audit_failed=1
    else
        echo "$config_files" | while read -r line; do
            file_value=$(echo "$line" | awk -F= '{print $2}' | xargs)
            if [ "$file_value" != "$expected_value" ]; then
                echo " - $param_name is incorrectly set to $file_value in $(echo $line | awk -F: '{print $1'}). Expected: $expected_value."
                audit_failed=1
            else
                echo " - $param_name is correctly set to $expected_value in $(echo $line | awk -F: '{print $1'})."
            fi
        done
    fi

    return $audit_failed
}

# Parameters to audit
params_to_check=(
    "net.ipv4.conf.all.send_redirects=0"
    "net.ipv4.conf.default.send_redirects=0"
)

# Perform auditing
audit_failed=0
for param in "${params_to_check[@]}"; do
    param_name=$(echo "$param" | cut -d= -f1)
    expected_value=$(echo "$param" | cut -d= -f2)
    check_kernel_parameter "$param_name" "$expected_value" || audit_failed=1
done

# Final audit result
if [ "$audit_failed" -eq 1 ]; then
    echo -e "\n- Audit Result: ** FAIL **"
    exit 1
else
    echo -e "\n- Audit Result: ** PASS **"
    exit 0
fi
