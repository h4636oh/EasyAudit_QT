#!/bin/bash

# Backup the original auditd.conf file
sudo cp /etc/audit/auditd.conf /etc/audit/auditd.conf.bak

# Add or update the max_log_file_action parameter
if grep -q '^max_log_file_action' /etc/audit/auditd.conf; then
    sudo sed -i "s/^max_log_file_action.*/max_log_file_action = keep_logs/" /etc/audit/auditd.conf
else
    echo "max_log_file_action = keep_logs" | sudo tee -a /etc/audit/auditd.conf
fi

# Restart the auditd service to apply the changes
sudo systemctl restart auditd

echo "max_log_file_action has been set to keep_logs in /etc/audit/auditd.conf and the auditd service has been restarted."

