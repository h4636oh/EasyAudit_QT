#!/bin/bash

# Verify aide is installed
if dpkg-query -s aide &>/dev/null; then
    echo "aide is installed"
else
    echo "aide is not installed"
    exit 1
fi

# Verify aide-common is installed
if dpkg-query -s aide-common &>/dev/null; then
    echo "aide-common is installed"
else
    echo "aide-common is not installed"
    exit 1
fi

