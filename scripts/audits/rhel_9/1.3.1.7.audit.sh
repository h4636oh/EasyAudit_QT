#!/bin/bash

# Script to audit if the MCS Translation Service (mcstrans) is installed on the system.

# Check if the mcstrans package is installed
if rpm -q mcstrans &> /dev/null; then
    echo "Audit Failed: mcstrans package is installed."
    echo "Please remove it manually as per your organization policy."
    exit 1
else
    echo "Audit Passed: mcstrans package is not installed."
    exit 0
fi

