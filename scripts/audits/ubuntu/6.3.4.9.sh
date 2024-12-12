#!/usr/bin/env bash

# Verify that the audit tools are owned by the root user
ownership_check=$(stat -Lc "%n %U" /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules | awk '$2 != "root" {print}')

if [[ -z "$ownership_check" ]]; then
    echo "All audit tools are owned by root."
else
    echo "Warning: Some audit tools are not owned by root:"
    echo "$ownership_check"
    exit 1
fi

