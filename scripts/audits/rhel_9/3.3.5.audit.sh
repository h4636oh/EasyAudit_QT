#!/usr/bin/env bash

# This script audits the ICMP redirect settings to ensure they are not accepted.
# According to security guidelines, the following parameters should be set to 0.

# Array of parameters to check
params=(
    "net.ipv4.conf.all.accept_redirects=0"
    "net.ipv4.conf.default.accept_redirects=0"
    "net.ipv6.conf.all.accept_redirects=0"
    "net.ipv6.conf.default.accept_redirects=0"
)

# Check if IPv6 is disabled on the system
ipv6_disabled=no
if [ "$(cat /proc/sys/net/ipv6/conf/all/disable_ipv6)" -eq 1 ]; then
    ipv6_disabled=yes
fi

# Function to perform the audit check for each parameter
audit_network_param() {
    param=$1
    expected_value=${param#*=}

    # Check the running configuration
    sysctl_value=$(sysctl -n "${param%=*}")
    if [[ "$sysctl_value" != "$expected_value" ]]; then
        echo "FAIL: $param is set to $sysctl_value, expected $expected_value in running config."
        return 1
    fi

    # Check configuration files
    files_checked=$(grep -rl "${param%=*}" /etc/sysctl.conf /etc/sysctl.d/*)

    if ! echo "$files_checked" | xargs grep -q "^${param//./\\.}[[:space:]]*=[[:space:]]*$expected_value" 2>/dev/null; then
        echo "FAIL: $param is not correctly set in configuration files."
        return 1
    fi

    echo "PASS: $param is correctly set."
    return 0
}

# Initialize pass/fail counters
pass_count=0
fail_count=0

# Perform audit for each parameter
for param in "${params[@]}"; do
    # Skip IPv6 checks if IPv6 is disabled
    if [[ $ipv6_disabled == yes && $param == net.ipv6.* ]]; then
        echo "SKIP: $param is not applicable because IPv6 is disabled."
        continue
    fi

    if ! audit_network_param "$param"; then
        fail_count=$((fail_count + 1))
    else
        pass_count=$((pass_count + 1))
    fi
done

# Summary and exit status
if (( fail_count > 0 )); then
    echo "Audit Result: **FAIL**"
    echo "$fail_count parameter(s) failed the audit."
    exit 1
else
    echo "Audit Result: **PASS**"
    echo "All parameters are correctly set."
    exit 0
fi

# This script checks the ICMP redirect settings according to the specified configuration requirements. It evaluates both the live settings using `sysctl` and the persisted configurations in `/etc/sysctl.conf` or `/etc/sysctl.d/*.conf`. It will skip checks for IPv6 parameters if IPv6 is found to be disabled on the system.