#!/usr/bin/env bash

# Exit codes
PASS=0
FAIL=1

# Variables to track audit results
output_pass=""
output_fail=""
firewall_type=""

# Check if either firewalld or nftables is enabled
if systemctl is-enabled firewalld.service | grep -q 'enabled'; then
    echo -e "\n- FirewallD is in use on the system"
    firewall_type="firewalld"
elif systemctl is-enabled nftables.service 2>/dev/null | grep -q 'enabled'; then
    echo -e "\n- nftables is in use on the system"
    firewall_type="nftables"
else
    echo -e "\n- Error: Neither FirewallD nor NFTables is enabled."
    echo -e "Please ensure a single firewall configuration utility is in use."
    exit $FAIL
fi

# Audit for firewalld configuration
if [ "$firewall_type" = "firewalld" ]; then
    # Check if loopback traffic is accepted
    if nft list ruleset | awk '/hook\s+input\s+/,/\}\s*(#.*)?$/' | grep -Pq -- '\H+\h+"lo"\h+accept'; then
        output_pass+="- Network traffic to the loopback address is correctly set to accept\n"
    else
        output_fail+="- Network traffic to the loopback address is not set to accept\n"
    fi

    # Check IPv4 loopback traffic drop configuration
    ipv4_rules=$(nft list ruleset | awk '/filter_IN_public_deny|hook\s+input\s+/,/\}\s*(#.*)?$/' | grep -P -- 'ip\h+saddr')
    if grep -Pq -- 'ip\h+saddr\h+127\.0\.0\.0/8\h+(counter\h+packets\h+\d+\h+bytes\h+\d+\h+)?drop' <<< "$ipv4_rules" \
        || grep -Pq -- 'ip\h+daddr\h+!\=\h+127\.0\.0\.1\h+ip\h+saddr\h+127\.0\.0\.1\h+drop' <<< "$ipv4_rules"; then
        output_pass+="- IPv4 network traffic from loopback address correctly set to drop\n"
    else
        output_fail+="- IPv4 network traffic from loopback address not set to drop\n"
    fi

    # Check IPv6 loopback traffic drop configuration if IPv6 is enabled
    if grep -Pq -- '^\h*0\h*$' /sys/module/ipv6/parameters/disable; then
        ipv6_rules=$(nft list ruleset | awk '/filter_IN_public_deny|hook input/,/}/' | grep 'ip6 saddr')
        if grep -Pq -- 'ip6\h+saddr\h+::1\h+(counter\h+packets\h+\d+\h+bytes\h+\d+\h+)?drop' <<< "$ipv6_rules" \
            || grep -Pq -- 'ip6\h+daddr\h+!\=\h+::1\h+ip6\h+saddr\h+::1\h+drop' <<< "$ipv6_rules"; then
            output_pass+="- IPv6 network traffic from loopback address correctly set to drop\n"
        else
            output_fail+="- IPv6 network traffic from loopback address not set to drop\n"
        fi
    fi
fi

# Determine audit result
if [ -n "$output_fail" ]; then
    echo -e "\n- Audit Result:\n*** FAIL ***\n$output_fail\n\n- Correctly set:\n$output_pass"
    exit $FAIL
else
    echo -e "\n- Audit Result:\n*** PASS ***\n$output_pass"
    exit $PASS
fi
