#!/bin/bash

# Function to stop and mask services
stop_and_mask_services() {
    echo "Stopping and masking dovecot.socket and dovecot.service..."
    systemctl stop dovecot.socket dovecot.service
    systemctl mask dovecot.socket dovecot.service
    echo "dovecot.socket and dovecot.service stopped and masked."
}

# Check if dovecot-imapd or dovecot-pop3d are installed
if dpkg-query -s dovecot-imapd &>/dev/null; then
    echo "dovecot-imapd is installed"
    package_installed=true
else
    echo "dovecot-imapd is not installed"
    package_installed=false
fi

if dpkg-query -s dovecot-pop3d &>/dev/null; then
    echo "dovecot-pop3d is installed"
    package_installed=true
else
    echo "dovecot-pop3d is not installed"
fi

# If either package is installed, attempt to stop and purge them
if [ "$package_installed" = true ]; then
    echo "Stopping dovecot.socket and dovecot.service..."
    systemctl stop dovecot.socket dovecot.service

    echo "Attempting to purge dovecot-imapd and dovecot-pop3d..."
    if apt purge -y dovecot-imapd dovecot-pop3d; then
        echo "dovecot-imapd and dovecot-pop3d packages purged successfully."
    else
        echo "Failed to purge dovecot-imapd and/or dovecot-pop3d. They may be required by dependencies."
        stop_and_mask_services
    fi
else
    echo "Neither dovecot-imapd nor dovecot-pop3d are installed."
fi

