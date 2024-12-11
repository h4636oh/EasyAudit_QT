#!/usr/bin/env bash

# Script to audit if tcp_syncookies is enabled

audit_tcp_syncookies() {
    local fail=0
    local result
    local output=""

    # Check current running configuration for tcp_syncookies
    result=$(sysctl net.ipv4.tcp_syncookies | awk -F= '{print $2}' | xargs)
    if [ "$result" != "1" ]; then
        output=" - 'net.ipv4.tcp_syncookies' is incorrectly set in the running configuration.\n"
        fail=1
    else
        output=" - 'net.ipv4.tcp_syncookies' is correctly set to '1' in the running configuration.\n"
    fi

    # Check if the setting exists in sysctl files
    local file_check=$(grep -P '^\\s*net\\.ipv4\\.tcp_syncookies\\h*=\\h*1\\b' /etc/sysctl.conf /etc/sysctl.d/*.conf 2>/dev/null)

    if [ -z "$file_check" ]; then
        output+=" - 'net.ipv4.tcp_syncookies' is not set correctly in configuration files.\n"
        fail=1
    else
        output+=" - 'net.ipv4.tcp_syncookies' is set correctly in kernel parameter configuration files.\n"
    fi

    # Output the result
    if [ "$fail" -eq 0 ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$output"
        exit 0
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$output"
        exit 1
    fi
}

# Execute audit function
audit_tcp_syncookies

# Comments:
# - This script checks if the `net.ipv4.tcp_syncookies` parameter is set to 1 both in the current running configuration and in the persistent sysctl files.
# - It exits with code 0 if both checks pass and with code 1 if any check fails.
# - It assumes that the relevant sysctl configurations are stored within `/etc/sysctl.conf` and files under `/etc/sysctl.d/`. Adjustments may be necessary if configurations are stored elsewhere.