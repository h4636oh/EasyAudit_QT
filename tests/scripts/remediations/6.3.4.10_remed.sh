#!/usr/bin/env bash

# Change group ownership of the audit tools to root
sudo chgrp root /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules

echo "Group ownership of the specified audit tools has been changed to root"

