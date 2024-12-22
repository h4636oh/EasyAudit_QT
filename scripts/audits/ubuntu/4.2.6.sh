#!/usr/bin/env bash

# Verify the loopback interface is configured to accept network traffic
echo "Checking loopback interface configuration to accept network traffic..."
lo_accept=$(sudo nft list ruleset | awk '/hook input/,/}/' | grep 'iif "lo" accept')
if [[ -n "$lo_accept" ]]; then
  echo "Loopback interface is configured to accept network traffic:"
  echo "$lo_accept"
else
  echo "Loopback interface is not configured to accept network traffic."
fi

# Verify network traffic from an IPv4 loopback interface is configured to drop
echo "Checking IPv4 loopback interface configuration to drop network traffic..."
ip4_drop=$(sudo nft list ruleset | awk '/hook input/,/}/' | grep 'ip saddr')
if [[ -n "$ip4_drop" ]]; then
  echo "IPv4 loopback interface is configured to drop network traffic:"
  echo "$ip4_drop"
else
  echo "IPv4 loopback interface is not configured to drop network traffic."
fi

# Verify network traffic from an IPv6 loopback interface is configured to drop
echo "Checking IPv6 loopback interface configuration to drop network traffic..."
ip6_drop=$(sudo nft list ruleset | awk '/hook input/,/}/' | grep 'ip6 saddr')
if [[ -n "$ip6_drop" ]]; then
  echo "IPv6 loopback interface is configured to drop network traffic:"
  echo "$ip6_drop"
else
  echo "IPv6 loopback interface is not configured to drop network traffic."
fi

