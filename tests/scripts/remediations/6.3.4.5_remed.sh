#!/usr/bin/env bash

# Remove more permissive mode than 0640 from the audit configuration files
sudo find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) -exec chmod u-x,g-wx,o-rwx {} +

echo "Permissions for audit configuration files in /etc/audit/ have been updated to 0640 or less permissive"

