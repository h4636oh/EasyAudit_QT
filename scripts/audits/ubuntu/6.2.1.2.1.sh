#!/bin/bash

# Verify if systemd-journal-remote is installed
if dpkg-query -s systemd-journal-remote &>/dev/null; then
    echo "systemd-journal-remote is installed"
else
    echo "systemd-journal-remote is not installed"
    exit 1
fi

