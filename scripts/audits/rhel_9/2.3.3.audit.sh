#!/bin/bash

# This script audits if the chrony service in /etc/sysconfig/chronyd
# is configured to run as the root user. According to security best practices,
# it should not be run as root.

# Run the command to check the configuration of chrony
output=$(grep -Psi -- '^\h*OPTIONS=\"?\h*([^#\n\r]+\h+)?-u\h+root\b' /etc/sysconfig/chronyd)

# Check if anything was returned by the grep command
if [[ -n "$output" ]]; then
    echo "Audit failed: It seems that chrony is configured to run as the root user."
    echo "Please edit the file /etc/sysconfig/chronyd and remove '-u root' from any OPTIONS= argument."
    exit 1
else
    echo "Audit passed: Chrony is not configured to run as the root user."
    exit 0
fi