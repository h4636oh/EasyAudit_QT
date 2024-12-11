#!/bin/bash

# Check on-disk rules
echo "Checking on-disk rules:"
on_disk_rules=$(awk '/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && (/ -F *auid!=unset/ || / -F *auid!=-1/ || / -F *auid!=4294967295/) && (/ -C *euid!=uid/ || / -C *uid!=euid/) && / -S *execve/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/' /etc/audit/rules.d/*.rules)

expected_on_disk_rules="-a always,exit -F arch=b64 -C euid!=uid -F auid!=unset -S execve -k user_emulation
-a always,exit -F arch=b32 -C euid!=uid -F auid!=unset -S execve -k user_emulation"

if [ "$on_disk_rules" == "$expected_on_disk_rules" ]; then
    echo "On-disk rules match expected values."
else
    echo "On-disk rules do not match expected values:"
    echo "$on_disk_rules"
    exit 1
fi

# Check running configuration rules
echo "Checking running configuration rules:"
running_rules=$(auditctl -l | awk '/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && (/ -F *auid!=unset/ || / -F *auid!=-1/ || / -F *auid!=4294967295/) && (/ -C *euid!=uid/ || / -C *uid!=euid/) && / -S *execve/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/')

expected_running_rules="-a always,exit -F arch=b64 -S execve -C uid!=euid -F auid!=-1 -F key=user_emulation 
-a always,exit -F arch=b32 -S execve -C uid!=euid -F auid!=-1 -F key=user_emulation"

if [ "$running_rules" == "$expected_running_rules" ]; then
    echo "Running configuration rules match expected values."
else
    echo "Running configuration rules do not match expected values:"
    echo "$running_rules"
    exit 1
fi

