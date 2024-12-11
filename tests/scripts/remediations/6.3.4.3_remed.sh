#!/usr/bin/env bash

# Ensure audit log files are group-owned by adm
if [ -f /etc/audit/auditd.conf ]; then
    log_dir=$(dirname "$(awk -F"=" '/^\s*log_file/ {print $2}' /etc/audit/auditd.conf | xargs)")
    sudo find "$log_dir" -type f \( ! -group adm -a ! -group root \) -exec chgrp adm {} +
    echo "Audit log files in $log_dir are now group-owned by adm"
else
    echo "Audit configuration file /etc/audit/auditd.conf not found."
    exit 1
fi

# Set the log_group parameter in the audit configuration file to log_group = adm
sudo sed -ri 's/^\s*#?\s*log_group\s*=\s*\S+(\s*#.*)?.*$/log_group = adm\1/' /etc/audit/auditd.conf
echo "Set log_group parameter to adm in /etc/audit/auditd.conf"

# Restart the audit daemon to reload the configuration file
sudo systemctl restart auditd
echo "Audit daemon restarted to apply the new configuration"

