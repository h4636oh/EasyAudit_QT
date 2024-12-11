#!/bin/bash

# Unmask the systemd-journal-upload service
sudo systemctl unmask systemd-journal-upload.service

# Enable and start the systemd-journal-upload service
sudo systemctl --now enable systemd-journal-upload.service

echo "systemd-journal-upload.service has been unmasked, enabled, and started."

