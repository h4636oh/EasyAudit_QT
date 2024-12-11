#!/bin/bash

echo "Verifying loopback interface configuration..."

# Check if loopback interface is set to accept traffic
echo "Checking loopback interface accepts traffic..."
lo_accept=$(nft list ruleset | awk '/hook input/,/}/' | grep 'iif "lo" accept')
if [[ -n $lo_accept ]]; then
    echo "PASS: Loopback interface accepts traffic."
    echo "$lo_accept"
else
    echo "FAIL: Loopback interface is not configured to accept traffic."
    exit 1
fi

# Check if IPv4 loopback traffic is set to drop
echo "Checking IPv4 loopback traffic drop configuration..."
ipv4_drop=$(nft list ruleset | awk '/hook input/,/}/' | grep 'ip saddr')
if [[ $ipv4_drop =~ "127.0.0.0/8" && $ipv4_drop =~ "drop" ]]; then
    echo "PASS: IPv4 loopback traffic is configured to drop."
    echo "$ipv4_drop"
else
    echo "FAIL: IPv4 loopback traffic is not configured to drop."
fi

# Check if IPv6 loopback traffic is set to drop (only if IPv6 is enabled)
if [[ -f /proc/net/if_inet6 ]]; then
    echo "Checking IPv6 loopback traffic drop configuration..."
    ipv6_drop=$(nft list ruleset | awk '/hook input/,/}/' | grep 'ip6 saddr')
    if [[ $ipv6_drop =~ "::1" && $ipv6_drop =~ "drop" ]]; then
        echo "PASS: IPv6 loopback traffic is configured to drop."
        echo "$ipv6_drop"
    else
        echo "FAIL: IPv6 loopback traffic is not configured to drop."
        exit 1
    fi
else
    echo "IPv6 is not enabled on this system."
    exit 1
fi