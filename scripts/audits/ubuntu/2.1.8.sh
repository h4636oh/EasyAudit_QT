#!/bin/bash

# Check if dovecot-imapd is installed
if dpkg-query -s dovecot-imapd &>/dev/null; then
    echo "dovecot-imapd is installed"
else
    echo "dovecot-imapd is not installed"
fi

# Check if dovecot-pop3d is installed
if dpkg-query -s dovecot-pop3d &>/dev/null; then
    echo "dovecot-pop3d is installed"
else
    echo "dovecot-pop3d is not installed"
fi

# Check if either package is installed
if dpkg-query -s dovecot-imapd &>/dev/null || dpkg-query -s dovecot-pop3d &>/dev/null; then
    # Check if dovecot.socket and dovecot.service are enabled
    if systemctl is-enabled dovecot.socket dovecot.service 2>/dev/null | grep 'enabled'; then
        echo "dovecot.socket or dovecot.service is enabled"
        exit 1
    else
        echo "dovecot.socket and dovecot.service are not enabled"
    fi

    # Check if dovecot.socket and dovecot.service are active
    if systemctl is-active dovecot.socket dovecot.service 2>/dev/null | grep '^active'; then
        echo "dovecot.socket or dovecot.service is active"
        exit 1
    else
        echo "dovecot.socket and dovecot.service are not active"
    fi
else
    echo "Neither dovecot-imapd nor dovecot-pop3d are installed"
fi

