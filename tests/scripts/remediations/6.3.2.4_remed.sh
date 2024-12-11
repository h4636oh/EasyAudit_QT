#!/bin/bash

# Backup the original auditd.conf file
sudo cp /etc/audit/auditd.conf /etc/audit/auditd.conf.bak

# Set the space_left_action and admin_space_left_action parameters
space_left_action="email"  # Replace with your preferred setting: email, exec, single, halt
admin_space_left_action="single"  # Replace with your preferred setting: single, halt

# Add or update the space_left_action parameter
if grep -q '^space_left_action' /etc/audit/auditd.conf; then
    sudo sed -i "s/^space_left_action.*/space_left_action = $space_left_action/" /etc/audit/auditd.conf
else
    echo "space_left_action = $space_left_action" | sudo tee -a /etc/audit/auditd.conf
fi

# Add or update the admin_space_left_action parameter
if grep -q '^admin_space_left_action' /etc/audit/auditd.conf; then
    sudo sed -i "s/^admin_space_left_action.*/admin_space_left_action = $admin_space_left_action/" /etc/audit/auditd.conf
else
    echo "admin_space_left_action = $admin_space_left_action" | sudo tee -a /etc/audit/auditd.conf
fi

# Restart the auditd service to apply the changes
sudo systemctl restart auditd

echo "space_left_action has been set to $space_left_action and admin_space_left_action has been set to $admin_space_left_action in /etc/audit/auditd.conf. The auditd service has been restarted."

