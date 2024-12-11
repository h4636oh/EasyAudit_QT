#!/usr/bin/env bash

# Change the owner of the audit tools to the root user
sudo chown root /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules

echo "Ownership of the specified audit tools has been changed to root"

