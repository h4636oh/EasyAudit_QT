#!/usr/bin/env bash

# Function to check if kernel parameter is correct
check_kernel_param() {
    local param_name="$1"
    local expected_value="$2"
    
    # Check current running configuration
    current_value=$(sysctl "$param_name" 2>/dev/null | awk -F'=' '{print $2}' | xargs)
    
    if [ "$current_value" != "$expected_value" ]; then
        echo " - \"$param_name\" is incorrectly set to \"$current_value\"; expected \"$expected_value\""
        return 1
    fi

    # Check configuration files for persistence settings
    persistent_files=$(grep -Elr "^\\s*$param_name\\s*=" /etc/sysctl.conf /etc/sysctl.d/*.conf /etc/ufw/sysctl.conf 2> /dev/null)
    
    if [ -z "$persistent_files" ]; then
        echo " - \"$param_name\" is not set persistently in any configuration file"
        return 1
    fi

    for file in $persistent_files; do
        file_value=$(grep -E "^\\s*$param_name\\s*=" "$file" | tail -n 1 | awk -F'=' '{print $2}' | xargs)
        if [ "$file_value" != "$expected_value" ]; then
            echo " - \"$param_name\" is incorrectly set in $file to \"$file_value\"; expected \"$expected_value\""
            return 1
        fi
    done
    
    echo " - \"$param_name\" is correctly set to \"$expected_value\" in running config and all checked files"
    return 0
}

# Variables for kernel parameters
declare -A params
params=( 
    ["net.ipv4.conf.all.log_martians"]="1"
    ["net.ipv4.conf.default.log_martians"]="1"
)

# Audit results
audit_passed=true

# Audit each parameter
echo "Auditing kernel parameters for suspicious packet logging:"
for param in "${!params[@]}"; do
    echo "Checking $param..."
    check_kernel_param "$param" "${params[$param]}"
    if [ $? -ne 0 ]; then
        audit_passed=false
    fi
done

# Determine overall audit result
if $audit_passed; then
    echo "- Audit Result: ** PASS **"
    exit 0
else
    echo "- Audit Result: ** FAIL **"
    exit 1
fi
