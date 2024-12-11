#!/usr/bin/env bash

# This script audits the kernel parameter `kernel.yama.ptrace_scope` to ensure it is set to 1.

audit_success=true  # Flag to track audit success

# Function to check kernel parameter
kernel_parameter_chk() {
    local kpname=$1
    local kpvalue=$2
    local output=""
    local output_failure=""
    local running_value

    # Check the current running configuration
    running_value=$(sysctl "$kpname" 2>/dev/null | awk -F= '{print $2}' | xargs)
    if [ "$running_value" = "$kpvalue" ]; then
        output=" - \"$kpname\" is correctly set to \"$running_value\" in the running configuration"
    else
        output_failure=" - \"$kpname\" is incorrectly set to \"$running_value\" in the running configuration and should have a value of: \"$kpvalue\""
        audit_success=false
    fi

    # Check persistent configuration in sysctl files
    declare -A file_checks
    while read -r line; do
        if [ -n "$line" ]; then
            if [[ $line =~ ^\s*# ]]; then
                # It's a file reference
                file_checks["${line//# /}"]=""
            else
                key=$(awk -F= '{print $1}' <<< "$line" | xargs)
                if [ "$key" = "$kpname" ]; then
                    file_checks["$line"]=""
                fi
            fi
        fi
    done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*/[^#\n\r\h]+\.conf\b)')

    # Evaluate results from files
    if (( ${#file_checks[@]} > 0 )); then
        for file in "${!file_checks[@]}"; do
            value=$(grep -Po -- "$kpname=\K\H+" "$file" 2>/dev/null | xargs)
            if [ "$value" = "$kpvalue" ]; then
                output="$output\n - \"$kpname\" is correctly set to \"$value\" in \"$file\""
            else
                output_failure="$output_failure\n - \"$kpname\" is incorrectly set to \"$value\" in \"$file\" and should have a value of: \"$kpvalue\""
                audit_success=false
            fi
        done
    else
        output_failure="$output_failure\n - \"$kpname\" is not set in an included file"
        audit_success=false
    fi

    # Print results
    if $audit_success; then
        echo -e "\n- Audit Result:\n ** PASS **\n$output\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$output_failure\n"
        [ -n "$output" ] && echo -e "\n- Correctly set:\n$output\n"
    fi
}

# Main body - audit 'kernel.yama.ptrace_scope'
kernel_parameter_chk "kernel.yama.ptrace_scope" "1"

# Exit appropriately based on audit outcome
if $audit_success; then
    exit 0
else
    exit 1
fi

# This script audits whether the `kernel.yama.ptrace_scope` parameter is correctly set to `1`. It checks both the running configuration and persistent sysctl configuration files and reports the audit status, exiting with `0` on success and `1` on failure.