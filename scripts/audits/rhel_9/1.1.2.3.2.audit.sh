#!/bin/bash

# Script to audit if the 'nodev' mount option is set on the /home partition

# Verify that the 'nodev' option is set on the /home partition
findmnt -kn /home | grep -qw nodev
if [ $? -eq 0 ]; then
    echo "Audit passed: 'nodev' option is set on the /home partition."
    exit 0
else
    echo "Audit failed: 'nodev' option is not set on the /home partition."
    exit 1
fi

