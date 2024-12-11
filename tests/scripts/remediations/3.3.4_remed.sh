#!/usr/bin/env bash

# Add the parameter to /etc/sysctl.d/60-netipv4_sysctl.conf
printf '%s\n' "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.d/60-netipv4_sysctl.conf

# Apply the setting
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w net.ipv4.route.flush=1

echo "Kernel parameters have been updated."

