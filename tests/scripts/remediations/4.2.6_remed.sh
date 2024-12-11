#!/bin/bash

echo "Configuring loopback interface rules..."

# Ensure loopback interface accepts traffic
echo "Adding rule to accept traffic on loopback interface..."
nft add rule inet filter input iif lo accept 2>/dev/null
if [[ $? -eq 0 ]]; then
    echo "Rule added: Loopback interface accepts traffic."
else
    echo "Rule already exists or failed to add for loopback traffic acceptance."
    exit 1
fi

# Configure IPv4 loopback traffic to drop
echo "Adding rule to drop traffic from IPv4 loopback addresses..."
nft add rule inet filter input ip saddr 127.0.0.0/8 counter drop 2>/dev/null
if [[ $? -eq 0 ]]; then
    echo "Rule added: IPv4 loopback traffic is configured to drop."
else
    echo "Rule already exists or failed to add for IPv4 loopback drop."
fi

# Configure IPv6 loopback traffic to drop if IPv6 is enabled
if [[ -f /proc/net/if_inet6 ]]; then
    echo "Adding rule to drop traffic from IPv6 loopback addresses..."
    nft add rule inet filter input ip6 saddr ::1 counter drop 2>/dev/null
    if [[ $? -eq 0 ]]; then
        echo "Rule added: IPv6 loopback traffic is configured to drop."
    else
        echo "Rule already exists or failed to add for IPv6 loopback drop."
        exit 1
    fi
else
    echo "IPv6 is not enabled on this system. Skipping IPv6 rule configuration."
    exit 1
fi

echo "Loopback rules configuration completed."