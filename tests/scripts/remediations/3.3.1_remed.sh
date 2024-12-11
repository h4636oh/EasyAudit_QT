#!/usr/bin/env bash

# Set IPv4 forwarding parameter
printf '%s\n' "net.ipv4.ip_forward = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf

# Apply IPv4 settings
sysctl -w net.ipv4.ip_forward=0
sysctl -w net.ipv4.route.flush=1

# Check if IPv6 is enabled
if grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable; then
    echo "IPv6 is enabled"

    # Set IPv6 forwarding parameter
    printf '%s\n' "net.ipv6.conf.all.forwarding = 0" >> /etc/sysctl.d/60-netipv6_sysctl.conf

    # Apply IPv6 settings
    sysctl -w net.ipv6.conf.all.forwarding=0
    sysctl -w net.ipv6.route.flush=1
else
    echo "IPv6 is not enabled"
fi

