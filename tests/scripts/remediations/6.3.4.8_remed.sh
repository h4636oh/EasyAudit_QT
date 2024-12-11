#!/usr/bin/env bash

# Remove more permissive mode from the specified audit tools
sudo chmod go-w /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules

echo "Permissions for audit tools have been updated"

