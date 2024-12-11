#!/bin/bash

# Unmask the auditd service
sudo systemctl unmask auditd

# Enable the auditd service
sudo systemctl enable auditd

# Start the auditd service
sudo systemctl start auditd

echo "auditd service has been unmasked, enabled, and started."

