#!/usr/bin/env bash

# Set the minimum user ID
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

if [ -z "${UID_MIN}" ]; then
    echo "ERROR: Variable 'UID_MIN' is unset."
    exit 1
fi

# Check on-disk rules
echo "Checking on-disk rules:"
on_disk_rules=$(awk "/^ *-a *always,exit/ \
&&/ -F *arch=b(32|64)/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -S/ \
&&/ -F *auid>=${UID_MIN}/ \
&&(/chmod/||/fchmod/||/fchmodat/ ||/chown/||/fchown/||/fchownat/||/lchown/ ||/setxattr/||/lsetxattr/||/fsetxattr/ ||/removexattr/||/lremovexattr/||/fremovexattr/) \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/" /etc/audit/rules.d/*.rules)

expected_on_disk_rules=(
"-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=unset -F key=perm_mod"
"-a always,exit -F arch=b64 -S chown,fchown,lchown,fchownat -F auid>=1000 -F auid!=unset -F key=perm_mod"
"-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=unset -F key=perm_mod"
"-a always,exit -F arch=b32 -S lchown,fchown,chown,fchownat -F auid>=1000 -F auid!=unset -F key=perm_mod"
"-a always,exit -F arch=b64 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=unset -F key=perm_mod"
"-a always,exit -F arch=b32 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=unset -F key=perm_mod"
)

for rule in "${expected_on_disk_rules[@]}"; do
    if echo "$on_disk_rules" | grep -q "$rule"; then
        echo "OK: '$rule' found in on-disk configuration."
    else
        echo "Warning: '$rule' not found in on-disk configuration."
        exit 1
    fi
done

# Check running configuration rules
echo "Checking running configuration rules:"
running_rules=$(auditctl -l | awk "/^ *-a *always,exit/ \
&&/ -F *arch=b(32|64)/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -S/ \
&&/ -F *auid>=${UID_MIN}/ \
&&(/chmod/||/fchmod/||/fchmodat/ ||/chown/||/fchown/||/fchownat/||/lchown/ ||/setxattr/||/lsetxattr/||/fsetxattr/ ||/removexattr/||/lremovexattr/||/fremovexattr/) \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/")

expected_running_rules=(
"-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=-1 -F key=perm_mod"
"-a always,exit -F arch=b64 -S chown,fchown,lchown,fchownat -F auid>=1000 -F auid!=-1 -F key=perm_mod"
"-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=-1 -F key=perm_mod"
"-a always,exit -F arch=b32 -S lchown,fchown,chown,fchownat -F auid>=1000 -F auid!=-1 -F key=perm_mod"
"-a always,exit -F arch=b64 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=-1 -F key=perm_mod"
"-a always,exit -F arch=b32 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=-1 -F key=perm_mod"
)

for rule in "${expected_running_rules[@]}"; do
    if echo "$running_rules" | grep -q "$rule"; then
        echo "OK: '$rule' found in running configuration."
    else
        echo "Warning: '$rule' not found in running configuration."
        exit 1
    fi
done

