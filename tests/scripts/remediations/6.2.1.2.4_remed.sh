#!/bin/bash

# Stop the systemd-journal-remote.socket and systemd-journal-remote.service
sudo systemctl stop systemd-journal-remote.socket systemd-journal-remote.service

# Mask the systemd-journal-remote.socket and systemd-journal-remote.service
sudo systemctl mask systemd-journal-remote.socket systemd-journal-remote.service

echo "systemd-journal-remote.socket and systemd-journal-remote.service have been stopped and masked."

