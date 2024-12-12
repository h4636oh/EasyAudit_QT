#!/usr/bin/env bash

# Verify log_group parameter is set to either adm or root in /etc/audit/auditd.conf
log_group_check=$(grep -Piws -- '^\h*log_group\h*=\h*\H+\b' /etc/audit/auditd.conf | grep -Pvi -- '(adm)')
if [[ -z "$log_group_check" ]]; then
    echo "log_group is set correctly."
else
    echo "Warning: log_group is not set to adm or root."
    exit 1
fi

# Check audit log files ownership
if [ -e /etc/audit/auditd.conf ]; then
    l_fpath="$(dirname "$(awk -F "=" '/^\s*log_file/ {print $2}' /etc/audit/auditd.conf | xargs)")"
    ownership_check=$(find -L "$l_fpath" -not -path "$l_fpath/lost+found" -type f \( ! -group root -a ! -group adm \) -exec ls -l {} +)
    if [[ -z "$ownership_check" ]]; then
        echo "All audit log files are owned by root or adm group."
    else
        echo "Warning: Some audit log files are not owned by root or adm group:"
        echo "$ownership_check"
        exit 1
    fi
else
    echo "Audit configuration file /etc/audit/auditd.conf not found."
fi

