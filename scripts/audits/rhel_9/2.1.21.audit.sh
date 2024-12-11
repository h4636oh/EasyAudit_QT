#!/bin/bash

# Audit script to ensure Mail Transfer Agents are configured for local-only mode.
# Requirements:
# - Check if the MTA is not listening on any non-loopback address.
# - Only audit, do not make changes.

set -e

# Define the ports associated with common Mail Transfer Agents
MTA_PORTS=("25" "465" "587")


# Function to audit the MTA configuration
audit_mta_configuration() {
    local output_pass=""
    local output_fail=""
    local mta_interface

    # Check if the Postfix is configured for all interfaces
    mta_interface=$(postconf -n inet_interfaces)

    if [ "$mta_interface" != "inet_interfaces = all" ]; then
        # Loop over each MTA-related port
        for port in "${MTA_PORTS[@]}"; do
            # Check if the port is listening on a non-loopback address
            if ss -plntu | grep -P ":$port\\b" | grep -Pvq "\\s+(127\\.0\\.0\\.1|\\[?::1\\]?):$port\\b"; then
                output_fail+=$'\n'" - Port \"$port\" is listening on a non-loopback network interface"
            else
                output_pass+=$'\n'" - Port \"$port\" is not listening on a non-loopback network interface"
            fi
        done
    else
        output_fail+=$'\n'" - Postfix is bound to all interfaces"
    fi

    # Display audit results
    if [ -z "$output_fail" ]; then
        echo -e "\\n- Audit Result: ** PASS **\\n$output_pass\\n"
        exit 0
    else
        echo -e "\\n- Audit Result: ** FAIL **\\n - Reason(s) for audit failure:$output_fail\\n"
        [ -n "$output_pass" ] && echo -e "\\n- Correctly set:$output_pass\\n"
        exit 1
    fi
}

# Run audit
audit_mta_configuration

### Notes:
# - The script uses `ss` for socket statistics instead of `netstat`, as it is more modern and commonly available on Linux systems.
# - This script should be run with sufficient privileges to check network interfaces and running services.
# - `postconf` is used to query Postfix configurations. Adjust this if another MTA is in use, or consult specific documentation for your MTA.
# - The script exits with `0` if MTA is correctly bound to only loopback interfaces, `1` otherwise.