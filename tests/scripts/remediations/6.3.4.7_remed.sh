#!/usr/bin/env bash

# Change group ownership of audit configuration files to root
sudo find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -group root -exec chgrp root {} +

echo "Group ownership of audit configuration files in /etc/audit/ has been updated to root"

