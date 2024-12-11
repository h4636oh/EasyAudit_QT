#!/bin/bash

# Verify if auditd is installed
if dpkg-query -s auditd &>/dev/null; then
    echo "auditd is installed"
else
    echo "auditd is not installed"
fi

# Verify if audispd-plugins is installed
if dpkg-query -s audispd-plugins &>/dev/null; then
    echo "audispd-plugins is installed"
else
    echo "audispd-plugins is not installed"
    exit 1
fi

