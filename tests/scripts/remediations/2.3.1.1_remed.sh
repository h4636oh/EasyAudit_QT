#!/bin/bash

echo "Select time synchronization daemon:"
echo "1. chrony"
echo "2. systemd-timesyncd"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo "Installing chrony..."
        apt update && apt install -y chrony

        echo "Stopping and masking systemd-timesyncd.service..."
        systemctl stop systemd-timesyncd.service
        systemctl mask systemd-timesyncd.service

        echo "chrony is installed and systemd-timesyncd is stopped and masked."
        ;;
    2)
        echo "Removing chrony..."
        apt purge -y chrony
        apt autoremove -y

        echo "Ensuring systemd-timesyncd is enabled and active..."
        systemctl unmask systemd-timesyncd.service
        systemctl start systemd-timesyncd.service
        systemctl enable systemd-timesyncd.service

        echo "systemd-timesyncd is enabled and active."
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

