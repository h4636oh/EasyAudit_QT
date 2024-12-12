#!/usr/bin/env bash

# Audit script for monitoring kernel module loading, unloading, and modification.
# Exits with 0 if audit configuration is as expected, otherwise exits with 1.

# Audit for on-disk configuration
check_disk_configuration() {
    echo "Checking on-disk audit rules..."
    awk '/^ *-a *always,exit/ \
    &&/ -F *arch=b(32|64)/ \
    &&(/ -F auid!=unset/||/ -F auid!=-1/||/ -F auid!=4294967295/) \
    &&/ -S/ \
    &&(/init_module/ \
    ||/finit_module/ \
    ||/delete_module/ \
    ||/create_module/ \
    ||/query_module/) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules > /tmp/disk_audit_check.txt
    
    UID_MIN=$(awk '/^\\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -n "${UID_MIN}" ]; then
        awk "/^ *-a *always,exit/ \
        &&(/ -F auid!=unset/||/ -F auid!=-1/||/ -F auid!=4294967295/) \
        &&/ -F *auid>=${UID_MIN}/ \
        &&/ -F *perm=x/ \
        &&/ -F *path=\\/usr\\/bin\\/kmod/ \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules >> /tmp/disk_audit_check.txt || {
            echo "ERROR: Variable 'UID_MIN' is unset."
            return 1
        }
    fi

    expected_output='-a always,exit -F arch=b64 -S
init_module,finit_module,delete_module,create_module,query_module -F
auid>=1000 -F auid!=unset -k kernel_modules
-a always,exit -F path=/usr/bin/kmod -F perm=x -F auid>=1000 -F auid!=unset -
k kernel_modules'

    if grep -qF "${expected_output}" /tmp/disk_audit_check.txt; then
        echo "On-disk configuration is correct."
        return 0
    else
        echo "On-disk configuration is incorrect."
        return 1
    fi
}

# Audit for running configuration
check_running_configuration() {
    echo "Checking running audit rules..."
    auditctl -l | awk '/^ *-a *always,exit/ \
    &&/ -F *arch=b(32|64)/ \
    &&(/ -F auid!=unset/||/ -F auid!=-1/||/ -F auid!=4294967295/) \
    &&/ -S/ \
    &&(/init_module/ \
    ||/finit_module/ \
    ||/delete_module/ \
    ||/create_module/ \
    ||/query_module/) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' > /tmp/running_audit_check.txt
    
    UID_MIN=$(awk '/^\\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -n "${UID_MIN}" ]; then
        auditctl -l | awk "/^ *-a *always,exit/ \
        &&(/ -F auid!=unset/||/ -F auid!=-1/||/ -F auid!=4294967295/) \
        &&/ -F *auid>=${UID_MIN}/ \
        &&/ -F *perm=x/ \
        &&/ -F *path=\\/usr\\/bin\\/kmod/ \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" >> /tmp/running_audit_check.txt || {
            echo "ERROR: Variable 'UID_MIN' is unset."
            return 1
        }
    fi

    expected_output='-a always,exit -F arch=b64 -S
create_module,init_module,delete_module,query_module,finit_module -F
auid>=1000 -F auid!=-1 -F key=kernel_modules
-a always,exit -S all -F path=/usr/bin/kmod -F perm=x -F auid>=1000 -F
auid!=-1 -F key=kernel_modules'

    if grep -qF "${expected_output}" /tmp/running_audit_check.txt; then
        echo "Running configuration is correct."
        return 0
    else
        echo "Running configuration is incorrect."
        return 1
    fi
}

# Audit Symlink
check_symlinks() {
    echo "Checking kmod symlinks..."
    a_files=("/usr/sbin/lsmod" "/usr/sbin/rmmod" "/usr/sbin/insmod" \
    "/usr/sbin/modinfo" "/usr/sbin/modprobe" "/usr/sbin/depmod")
    for l_file in "${a_files[@]}"; do
        if [ "$(readlink -f "$l_file")" = "$(readlink -f /bin/kmod)" ]; then
            echo "OK: \"$l_file\""
        else
            echo "Issue with symlink for file: \"$l_file\""
            return 1
        fi
    done
    return 0
}

# Main execution block
if check_disk_configuration && check_running_configuration && check_symlinks; then
    echo "All audit checks passed."
    exit 0
else
    echo "One or more audit checks failed."
    exit 1
fi