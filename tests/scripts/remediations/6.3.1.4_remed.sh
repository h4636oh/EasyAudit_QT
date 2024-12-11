#!/usr/bin/env bash

# Backup the original grub file
sudo cp /etc/default/grub /etc/default/grub.bak

# Add audit_backlog_limit=8192 to GRUB_CMDLINE_LINUX if it's not already present
if grep -q '^GRUB_CMDLINE_LINUX=' /etc/default/grub; then
    sudo sed -i 's/^GRUB_CMDLINE_LINUX="\([^"]*\)"/GRUB_CMDLINE_LINUX="\1 audit_backlog_limit=8192"/' /etc/default/grub
else
    echo 'GRUB_CMDLINE_LINUX="audit_backlog_limit=8192"' | sudo tee -a /etc/default/grub
fi

# Update the grub2 configuration
sudo update-grub

echo "audit_backlog_limit=8192 has been added to GRUB_CMDLINE_LINUX, and the grub2 configuration has been updated."

