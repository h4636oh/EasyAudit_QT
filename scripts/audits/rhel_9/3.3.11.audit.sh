#!/usr/bin/env bash

# This script audits if IPv6 router advertisements are not accepted
# It checks the kernel parameters net.ipv6.conf.all.accept_ra and net.ipv6.conf.default.accept_ra
# The expected value for both parameters is 0

# Function to check if IPv6 is disabled
f_ipv6_chk() {
    local ipv6_disabled="no"
    # Check if IPv6 is disabled in the system
    ! grep -Pqs '^\\h*0\\b' /sys/module/ipv6/parameters/disable || ipv6_disabled="yes"
    if sysctl net.ipv6.conf.all.disable_ipv6 | grep -Pqs "^\\h*net\\.ipv6\\.conf\\.all\\.disable_ipv6\\h*=\\h*1\\b" && \
       sysctl net.ipv6.conf.default.disable_ipv6 | grep -Pqs "^\\h*net\\.ipv6\\.conf\\.default\\.disable_ipv6\\h*=\\h*1\\b"; then
        ipv6_disabled="yes"
    fi
    echo "$ipv6_disabled"
}

# Function to audit kernel parameters
f_kernel_parameter_chk() {
    local kpname="$1"
    local kpvalue="$2"
    local krp
    krp="$(sysctl "$kpname" | awk -F= '{print $2}' | xargs)"
    if [ "$krp" != "$kpvalue" ]; then
        echo "FAIL: $kpname is set to $krp in running config, expected $kpvalue"
        return 1
    fi

    # Check configuration files
    local found_correct_value=false
    while IFS= read -r line; do
        if [[ "$line" =~ ^\\s*# ]]; then
            continue # Skip comments
        fi
        local found_name found_value
        found_name=$(awk -F= '{print $1}' <<< "$line" | xargs)
        found_value=$(awk -F= '{print $2}' <<< "$line" | xargs)
        
        if [ "$found_name" = "$kpname" ]; then
            if [ "$found_value" = "$kpvalue" ]; then
                found_correct_value=true
                break
            fi
        fi
    done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po "^\\s*$kpname\\s*=\\s*\\S+")

    if [ "$found_correct_value" = true ]; then
        echo "PASS: $kpname is correctly set in configuration files"
    else
        echo "FAIL: $kpname is not correctly set in configuration files"
        return 1
    fi
    return 0
}

# Main script execution
ipv6_disabled="$(f_ipv6_chk)"

# If IPv6 is disabled, the test is not applicable
if [ "$ipv6_disabled" = "yes" ]; then
    echo "PASS: IPv6 is disabled, checks are not applicable"
    exit 0
fi

# Kernel parameters to check
declare -A params=(
    ["net.ipv6.conf.all.accept_ra"]="0"
    ["net.ipv6.conf.default.accept_ra"]="0"
)

# Initialize audit result
audit_pass=true

# Check all parameters
for param in "${!params[@]}"; do
    f_kernel_parameter_chk "$param" "${params[$param]}"
    if [ $? -ne 0 ]; then
        audit_pass=false
    fi
done

# Final compliance status
if [ "$audit_pass" = true ]; then
    echo "Audit PASSED: All parameters are correctly set."
    exit 0
else
    echo "Audit FAILED: Some parameters are not correctly set."
    exit 1
fi
