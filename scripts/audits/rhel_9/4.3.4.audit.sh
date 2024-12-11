#!/usr/bin/env bash

# Audit script to ensure nftables are configured for loopback traffic

l_hbfw=""
l_output=""
l_output2=""

# Check if the system is using a firewall management utility
if systemctl is-enabled firewalld.service 2>/dev/null | grep -q 'enabled'; then
    echo -e "\n - FirewallD is in use on the system\n - Manual check needed for FirewallD configuration."
    exit 0 # Assume pass as we cannot audit FirewallD with nftables rules
elif systemctl is-enabled nftables.service | grep -q 'enabled'; then
    l_hbfw="nft"
else
    echo -e "\n - Error - Neither FirewallD nor NFTables is enabled\n - Please ensure a single firewall configuration utility is in use."
    exit 1
fi

# Audit nftables configurations for loopback traffic
if [ "$l_hbfw" = "nft" ]; then
    # Check if loopback interface is set to accept
    if nft list ruleset | awk '/hook\s+input\s+/,/}\s*(#.*)?$/' | grep -Pq -- '\siif\s+lo\s+accept'; then
        l_output="$l_output\n - Network traffic to the loopback address is correctly set to accept"
    else
        l_output2="$l_output2\n - Network traffic to the loopback address is not set to accept"
    fi
    
    # Check IPv4 loopback rules
    l_ipsaddr="$(nft list ruleset | awk '/filter_IN_public_deny|hook\s+input\s+/,/}\s*(#.*)?$/' | grep -P -- 'ip\s+saddr')"
    if grep -Pq -- 'ip\s+saddr\s+127\.0\.0\.1/8\s+drop' <<< "$l_ipsaddr"; then
        l_output="$l_output\n - IPv4 network traffic from the loopback address is correctly set to drop"
    else
        l_output2="$l_output2\n - IPv4 network traffic from the loopback address is not set to drop"
    fi

    # Check if IPv6 is enabled and verify loopback rules
    if grep -Pq -- '^\s*0\s*$' /sys/module/ipv6/parameters/disable; then
        l_ip6saddr="$(nft list ruleset | awk '/filter_IN_public_deny|hook input/,/}/' | grep 'ip6 saddr')"
        if grep -Pq -- 'ip6\s+saddr\s+::1/128\s+drop' <<< "$l_ip6saddr"; then
            l_output="$l_output\n - IPv6 network traffic from the loopback address is correctly set to drop"
        else
            l_output2="$l_output2\n - IPv6 network traffic from the loopback address is not set to drop"
        fi
    fi
fi

# Output audit results
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result:\n *** PASS ***\n$l_output"
    exit 0
else
    echo -e "\n- Audit Result:\n *** FAIL ***\n$l_output2\n\n - Correctly set:\n$l_output"
    exit 1
fi