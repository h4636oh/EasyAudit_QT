#!/usr/bin/env bash

# Verify that the audit configuration files are owned by the root user
ownership_check=$(sudo find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -user root)

if [[ -z "$ownership_check" ]]; then
    echo "All audit configuration files are owned by root."
else
    echo "Warning: Some audit configuration files are not owned by root:"
    echo "$ownership_check"
    exit 1
fi

