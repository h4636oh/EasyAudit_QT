#!/usr/bin/env bash

# Verify that the audit configuration files are owned by the root group
ownership_check=$(sudo find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -group root)

if [[ -z "$ownership_check" ]]; then
    echo "All audit configuration files are owned by the root group."
else
    echo "Warning: Some audit configuration files are not owned by the root group:"
    echo "$ownership_check"
    exit 1
fi

