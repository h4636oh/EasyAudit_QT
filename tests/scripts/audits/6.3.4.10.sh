#!/usr/bin/env bash

# Verify that the audit tools are owned by the root group
group_ownership_check=$(stat -Lc "%n %G" /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules | awk '$2 != "root" {print}')

if [[ -z "$group_ownership_check" ]]; then
    echo "All audit tools are owned by the root group."
else
    echo "Warning: Some audit tools are not owned by the root group:"
    echo "$group_ownership_check"
    exit 1
fi

