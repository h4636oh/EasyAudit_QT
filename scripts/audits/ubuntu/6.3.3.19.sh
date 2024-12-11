#!/usr/bin/env bash

# Set the minimum user ID
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

if [ -z "${UID_MIN}" ]; then
    echo "ERROR: Variable 'UID_MIN' is unset."
    exit 1
fi

# Check on-disk rules
echo "Checking on-disk rules for kernel modules:"
on_disk_rules=$(awk '/^ *-a *always,exit/ \
&&/ -F *arch=b(32|64)/ \
&&(/ -F auid!=unset/||/ -F auid!=-1/||/ -F auid!=4294967295/) \
&&/ -S/ \
&&(/init_module/ ||/finit_module/ ||/delete_module/) \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/' /etc/audit/rules.d/*.rules)

expected_on_disk_rules=(
"-a always,exit -F arch=b64 -S init_module,finit_module,delete_module -F auid>=1000 -F auid!=unset -k kernel_modules"
)

for rule in "${expected_on_disk_rules[@]}"; do
    if echo "$on_disk_rules" | grep -q "$rule"; then
        echo "OK: '$rule' found in on-disk configuration."
    else
        echo "Warning: '$rule' not found in on-disk configuration."
    fi
done

echo "Checking on-disk rules for kmod command:"
on_disk_rules_kmod=$(awk "/^ *-a *always,exit/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -F *auid>=${UID_MIN}/ \
&&/ -F *perm=x/ \
&&/ -F *path=\/usr\/bin\/kmod/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/" /etc/audit/rules.d/*.rules)

expected_on_disk_rules_kmod=(
"-a always,exit -F path=/usr/bin/kmod -F perm=x -F auid>=1000 -F auid!=unset -k kernel_modules"
)

for rule in "${expected_on_disk_rules_kmod[@]}"; do
    if echo "$on_disk_rules_kmod" | grep -q "$rule"; then
        echo "OK: '$rule' found in on-disk configuration."
    else
        echo "Warning: '$rule' not found in on-disk configuration."
    fi
done

# Check running configuration rules
echo "Checking running configuration rules for kernel modules:"
running_rules=$(auditctl -l | awk '/^ *-a *always,exit/ \
&&/ -F *arch=b(32|64)/ \
&&(/ -F auid!=unset/||/ -F auid!=-1/||/ -F auid!=4294967295/) \
&&/ -S/ \
&&(/init_module/ ||/finit_module/ ||/delete_module/) \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/')

expected_running_rules=(
"-a always,exit -F arch=b64 -S init_module,delete_module,finit_module -F auid>=1000 -F auid!=-1 -F key=kernel_modules"
)

for rule in "${expected_running_rules[@]}"; do
    if echo "$running_rules" | grep -q "$rule"; then
        echo "OK: '$rule' found in running configuration."
    else
        echo "Warning: '$rule' not found in running configuration."
        exit 1
    fi
done

echo "Checking running configuration rules for kmod command:"
running_rules_kmod=$(auditctl -l | awk "/^ *-a *always,exit/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -F *auid>=${UID_MIN}/ \
&&/ -F *perm=x/ \
&&/ -F path=\/usr\/bin\/kmod/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/")

expected_running_rules_kmod=(
"-a always,exit -S all -F path=/usr/bin/kmod -F perm=x -F auid>=1000 -F auid!=-1 -F key=kernel_modules"
)

for rule in "${expected_running_rules_kmod[@]}"; do
    if echo "$running_rules_kmod" | grep -q "$rule"; then
        echo "OK: '$rule' found in running configuration."
    else
        echo "Warning: '$rule' not found in running configuration."
        exit 1
    fi
done

# Symlink audit
echo "Checking symlinks for kmod:"
S_LINKS=$(ls -l /usr/sbin/lsmod /usr/sbin/rmmod /usr/sbin/insmod /usr/sbin/modinfo /usr/sbin/modprobe /usr/sbin/depmod | grep -vE " -> (\.\./)?bin/kmod" || true)
if [[ "${S_LINKS}" != "" ]]; then
    printf "Issue with symlinks: ${S_LINKS}\n"
    exit 1
else
    printf "OK\n"
fi

