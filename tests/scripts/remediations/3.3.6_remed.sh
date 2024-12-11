#!/usr/bin/env bash

# Add the parameters to /etc/sysctl.d/60-netipv4_sysctl.conf
printf '%s\n' "net.ipv4.conf.all.secure_redirects = 0" "net.ipv4.conf.default.secure_redirects = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf

# Apply the settings
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
sysctl -w net.ipv4.route.flush=1

echo "Kernel parameters have been updated."

