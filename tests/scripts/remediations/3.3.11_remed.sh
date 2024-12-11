#!/usr/bin/env bash

# Check if IPv6 is enabled
if grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable; then
    echo "IPv6 is enabled"

    # Add the parameters to /etc/sysctl.d/60-netipv6_sysctl.conf
    printf '%s\n' "net.ipv6.conf.all.accept_ra = 0" "net.ipv6.conf.default.accept_ra = 0" >> /etc/sysctl.d/60-netipv6_sysctl.conf

    # Apply the settings
    sysctl -w net.ipv6.conf.all.accept_ra=0
    sysctl -w net.ipv6.conf.default.accept_ra=0
    sysctl -w net.ipv6.route.flush=1

    echo "IPv6 parameters have been updated."
else
    echo "IPv6 is not enabled"
fi

