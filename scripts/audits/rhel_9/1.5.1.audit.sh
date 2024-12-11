#!/usr/bin/env bash

# Script to audit the kernel parameter: kernel.randomize_va_space

check_aslr_setting() {
    local expected_value=2
    local current_value
    local file_locations=()
    local incorrect_settings=()

    # Check current value in the running configuration
    current_value=$(sysctl kernel.randomize_va_space 2>/dev/null | awk -F= '{print $2}' | xargs)

    if [ "$current_value" != "$expected_value" ]; then
        incorrect_settings+=("Running configuration is set to $current_value but should be $expected_value")
    fi

    # Check durable settings in configuration files
    local config_files
    config_files=$(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\\h*([^#\\n\\r]+|#\\h*\\/[^#\\n\\r\\h]+\\.conf\\b)')

    while read -r line; do
        # Ignore comments
        if [[ $line =~ ^\\s*# ]]; then
            continue
        fi

        # Split the line into parameter and value
        local param
        local value
        param=$(awk -F= '{print $1}' <<< "$line" | xargs)
        value=$(awk -F= '{print $2}' <<< "$line" | xargs)

        if [ "$param" == "kernel.randomize_va_space" ]; then
            file_locations+=("$param is set to $value")
            if [ "$value" != "$expected_value" ]; then
                incorrect_settings+=("$param in a file is set to $value but should be $expected_value")
            fi
        fi
    done <<< "$config_files"

    # Output results
    if [ ${#incorrect_settings[@]} -eq 0 ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - All configurations are correctly set to $expected_value\n"
        return 0
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:"
        for issue in "${incorrect_settings[@]}"; do
            echo "  $issue"
        done
        echo -e "\n- File Settings:"
        for loc in "${file_locations[@]}"; do
            echo "  $loc"
        done
        return 1
    fi
}

# Run the ASLR check function and exit with the appropriate status code
check_aslr_setting
exit $?