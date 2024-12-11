#!/usr/bin/env bash

# This script audits journald log file access permissions as per site policies.
# It verifies if any override configuration exists and ensures permissions are 0640 or more restrictive.
# The script will exit with 0 if all checks pass, otherwise it will exit with 1 for any issues found.

file_path=""
override_file="/etc/tmpfiles.d/systemd.conf"
default_file="/usr/lib/tmpfiles.d/systemd.conf"
higher_permissions_found=false

# Check for the existence of either an override or default file
if [ -f "$override_file" ]; then
    file_path="$override_file"
elif [ -f "$default_file" ]; then
    file_path="$default_file"
else
    echo "Neither override nor default configuration file found."
    exit 1
fi

# Inspect the file for permissions higher than 0640
while IFS= read -r line; do
    # Check for permission patterns higher than 0640
    if echo "$line" | grep -Piq '^\s*[a-z]+\s+[^\s]+\s+0*([6-7][4-7][1-7]|7[0-7][0-7])\s+'; then
        higher_permissions_found=true
        break
    fi
done < "$file_path"

if [ "$higher_permissions_found" = true ]; then
    echo -e "\n- Audit Result:\n ** REVIEW **"
    echo -e "Permissions other than 0640 found in $file_path"
    echo -e " - Inspect $file_path and ensure permissions are set according to site policy."
    exit 1
else
    echo -e "All permissions inside $file_path are 0640 or more restrictive."
    echo -e "\n- Audit Result:\n ** PASS **"
    echo -e "$file_path exists and has correct permissions set"
    exit 0
fi
```
