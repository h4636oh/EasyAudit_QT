#!/bin/bash

# Check if xserver-common is installed
if dpkg-query -s xserver-common &>/dev/null; then
    echo "xserver-common is installed"
    exit 1
else
    echo "xserver-common is not installed"
fi

