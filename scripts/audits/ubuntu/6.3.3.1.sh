#!/bin/bash

# Check on-disk rules
echo "Checking on-disk rules:"
on_disk_rules=$(awk '/^ *-w/ && /\/etc\/sudoers/ && / +-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

if [ "$on_disk_rules" == "-w /etc/sudoers -p wa -k scope\n-w /etc/sudoers.d -p wa -k scope" ]; then
    echo "On-disk rules match expected values."
else
    echo "On-disk rules do not match expected values:"
    echo "$on_disk_rules"
    exit 1
fi

# Check running configuration rules
echo "Checking running configuration rules:"
running_rules=$(auditctl -l | awk '/^ *-w/ && /\/etc\/sudoers/ && / +-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)')

if [ "$running_rules" == "-w /etc/sudoers -p wa -k scope\n-w /etc/sudoers.d -p wa -k scope" ]; then
    echo "Running configuration rules match expected values."
else
    echo "Running configuration rules do not match expected values:"
    echo "$running_rules"
    exit 1
fi

