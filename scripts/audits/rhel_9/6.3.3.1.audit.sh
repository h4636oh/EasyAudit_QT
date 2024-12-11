#!/bin/bash

# Audit for sudoers monitoring in audit rules

# On-disk configuration check
on_disk_check=$(awk '/^ *-w/ \
&&/\/etc\/sudoers/ \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

expected_on_disk="-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d -p wa -k scope"

# Running configuration check
running_config_check=$(auditctl -l | awk '/^ *-w/ \
&&/\/etc\/sudoers/ \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)')

expected_running_config="-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d -p wa -k scope"

# Compare on-disk configuration
if [[ "$on_disk_check" != "$expected_on_disk" ]]; then
    echo "Failed: On-disk audit configuration does not match expected rules"
    exit 1
fi

# Compare running configuration
if [[ "$running_config_check" != "$expected_running_config" ]]; then
    echo "Failed: Running audit configuration does not match expected rules"
    exit 1
fi

# If all checks pass
echo "Audit passed: Sudoers monitoring rules are correctly configured"
exit 0