#!/usr/bin/env bash

# Add IPv4 parameters to /etc/sysctl.d/60-netipv4_sysctl.conf
printf '%s\n' "net.ipv4.conf.all.accept_source_route = 0" "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf

# Apply IPv4 settings
sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.default.accept_source_route=0
sysctl -w net.ipv4.route.flush=1

# Check if IPv6 is enabled
if grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable; then
    echo "IPv6 is enabled"

    # Add IPv6 parameters to /etc/sysctl.d/60-netipv6_sysctl.conf
    printf '%s\n' "net.ipv6.conf.all.accept_source_route = 0" "net.ipv6.conf.default.accept_source_route = 0" >> /etc/sysctl.d/60-netipv6_sysctl.conf

    # Apply IPv6 settings
    sysctl -w net.ipv6.conf.all.accept_source_route=0
    sysctl -w net.ipv6.conf.default.accept_source_route=0
    sysctl -w net.ipv6.route.flush=1
else
    echo "IPv6 is not enabled"
fi

echo "Kernel parameters have been updated."

