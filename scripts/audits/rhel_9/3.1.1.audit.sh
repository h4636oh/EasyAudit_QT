#!/usr/bin/env bash

# This script audits whether IPv6 is enabled or disabled on the system.
# It checks the status of IPv6 and reports it.
# The script should not modify or remidiate any system settings.

# Check if IPv6 is disabled via module parameters
if ! grep -Pqs '^\\h*0\\b' /sys/module/ipv6/parameters/disable; then
    if sysctl net.ipv6.conf.all.disable_ipv6 | grep -Pqs "^\\h*net\\.ipv6\\.conf\\.all\\.disable_ipv6\\h*=\\h*1\\b" && \
       sysctl net.ipv6.conf.default.disable_ipv6 | grep -Pqs "^\\h*net\\.ipv6\\.conf\\.default\\.disable_ipv6\\h*=\\h*1\\b"; then
        echo "Audit Passed: IPv6 is disabled on all interfaces"
        exit 0
    else
        echo "Audit Failed: IPv6 is not properly disabled"
        exit 1
    fi
else
    echo "Audit Passed: IPv6 is enabled"
    exit 0
fi

# If the audit reached here, it means the audit checks passed without clear indications
echo "Audit Indeterminate: Unable to determine IPv6 status."
exit 1

# This script audits the status of IPv6 on a Linux system by checking the relevant parameters to determine if IPv6 is enabled or disabled. The output clearly indicates whether the audit has passed or failed based on the findings.