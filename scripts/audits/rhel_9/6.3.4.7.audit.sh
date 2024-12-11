
#!/bin/bash

# Script to audit if audit configuration files in /etc/audit/ are owned by the group 'root'

# Findings audit configuration files that are not group owned by root
files=$(find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -group root)

# Check the output of the find command
if [ -z "$files" ]; then
  echo "Audit Passed: All audit configuration files are owned by the group 'root'."
  exit 0
else
  echo "Audit Failed: The following files are not group owned by 'root':"
  echo "$files"
  exit 1
fi
```

# Comments:
# This script checks if files in /etc/audit/ ending in .conf or .rules are group owned by 'root'.
# If no files are found (meaning they all have the correct permissions), the script exits with 0.
# Otherwise, the script exits with 1 and lists the files failing the audit. 
# The script is only for auditing and does not make any changes to the system.