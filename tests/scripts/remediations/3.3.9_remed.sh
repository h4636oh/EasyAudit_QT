#!/usr/bin/env bash

# Add the parameters to /etc/sysctl.d/60-netipv4_sysctl.conf
printf '%s\n' "net.ipv4.conf.all.log_martians = 1" "net.ipv4.conf.default.log_martians = 1" >> /etc/sysctl.d/60-netipv4_sysctl.conf

# Apply the settings
sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.conf.default.log_martians=1
sysctl -w net.ipv4.route.flush=1

echo "Kernel parameters have been updated."

