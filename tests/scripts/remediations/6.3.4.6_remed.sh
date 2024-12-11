#!/usr/bin/env bash

# Change ownership of audit configuration files to root user
sudo find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -user root -exec chown root {} +

echo "Ownership of audit configuration files in /etc/audit/ has been updated to root"

