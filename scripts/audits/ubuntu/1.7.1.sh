#!/bin/bash

# Check if gdm3 is installed
dpkg-query -s gdm3 &> /dev/null

if [ $? -eq 0 ]; then
    echo "gdm3 is installed. Please remove it."
    exit 1
else
    echo "gdm3 is not installed. This is expected."
fi
