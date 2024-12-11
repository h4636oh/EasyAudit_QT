#!/bin/bash

# Check if apparmor is installed
if dpkg-query -s apparmor &>/dev/null; then
    echo "apparmor is installed"
else
    echo "apparmor is not installed"
    exit 1
fi

# Check if apparmor-utils is installed
if dpkg-query -s apparmor-utils &>/dev/null; then
    echo "apparmor-utils is installed"
else
    echo "apparmor-utils is not installed"
    exit 1
fi

