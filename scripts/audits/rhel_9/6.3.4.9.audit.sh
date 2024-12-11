
#!/bin/bash

# Title: 6.3.4.9 Ensure audit tools owner is configured (Automated)
# Description: Verify that essential audit tools are owned by the root user as a security measure.

# Audit command to check ownership of audit tools
audit_output=$(stat -Lc "%n %U" /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules | awk '$2 != "root" {print}')

# Check if the output is empty (which means all tools are owned by root)
if [[ -z "$audit_output" ]]; then
  echo "Audit Passed: All audit tools are owned by the root user."
  exit 0
else
  echo "Audit Failed: The following audit tools are not owned by root:"
  echo "$audit_output"
  echo "Please manually change the ownership to root using the command:"
  echo "# chown root /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules"
  exit 1
fi
```
