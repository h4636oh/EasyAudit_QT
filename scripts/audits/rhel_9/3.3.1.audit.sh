#!/usr/bin/env bash

# This script audits the IP forwarding settings for IPv4 and IPv6.
# It checks if 'net.ipv4.ip_forward' and 'net.ipv6.conf.all.forwarding' are set to 0.
# IPv6 parameter is checked only if IPv6 is enabled.

set -e

audit_passed=true

# Check if IPv4 forwarding is disabled
ipv4_forward=$(sysctl net.ipv4.ip_forward | awk '{print $3}')
if [ "$ipv4_forward" -ne 0 ]; then
    echo "FAIL: net.ipv4.ip_forward is set to $ipv4_forward, should be 0"
    audit_passed=false
else
    echo "PASS: net.ipv4.ip_forward is correctly set to 0"
fi

# Check if IPv6 is enabled
ipv6_enabled=$(grep -Pqs '^\\h*0\\b' /sys/module/ipv6/parameters/disable)
if sysctl net.ipv6.conf.all.disable_ipv6 | grep -Pqs -- "^\\h*net\\.ipv6\\.conf\\.all\\.disable_ipv6\\h*=\\h*1\\b" && \
   sysctl net.ipv6.conf.default.disable_ipv6 | grep -Pqs -- "^\\h*net\\.ipv6\\.conf\\.default\\.disable_ipv6\\h*=\\h*1\\b"; then
    ipv6_enabled=false
fi

if [ "$ipv6_enabled" = false ]; then
    echo "IPv6 is disabled on the system, skipping IPv6 forwarding check"
else
    # Check if IPv6 forwarding is disabled
    ipv6_forward=$(sysctl net.ipv6.conf.all.forwarding | awk '{print $3}')
    if [ "$ipv6_forward" -ne 0 ]; then
        echo "FAIL: net.ipv6.conf.all.forwarding is set to $ipv6_forward, should be 0"
        audit_passed=false
    else
        echo "PASS: net.ipv6.conf.all.forwarding is correctly set to 0"
    fi
fi

# Exit with appropriate status
if [ "$audit_passed" = true ]; then
    exit 0
else
    exit 1
fi

# This script audits the kernel parameters for IP forwarding on both IPv4 and IPv6. It checks for the correct configuration (`0`) and exits with status `0` on success and `1` on failure. IPv6 parameters are evaluated only if IPv6 is enabled on the system. Comments and structure are provided to ensure clarity and adherence to best practices.