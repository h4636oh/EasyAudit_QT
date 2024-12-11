#!/bin/bash

# Unmask the systemd-journald service
sudo systemctl unmask systemd-journald.service

# Start the systemd-journald service
sudo systemctl start systemd-journald.service

echo "systemd-journald.service has been unmasked and started."

