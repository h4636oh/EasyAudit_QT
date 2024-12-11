#!/bin/bash

# Define the list of audit tools to check
audit_tools=(
  /sbin/auditctl
  /sbin/aureport
  /sbin/ausearch
  /sbin/autrace
  /sbin/auditd
  /sbin/augenrules
)

# Iterate through each tool and check its group ownership
for tool in "${audit_tools[@]}"; do
  if [ -e "$tool" ]; then
    group_owner=$(stat -Lc "%G" "$tool")
    if [ "$group_owner" != "root" ]; then
      echo "Group ownership of $tool is not root (current: $group_owner)"
      exit 1
    fi
  else
    echo "Tool $tool does not exist, skipping."
  fi
done

# If all tools are correctly configured
echo "All audit tools are correctly owned by the group root."
exit 0
