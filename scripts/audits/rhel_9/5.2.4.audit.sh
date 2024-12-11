
#!/bin/bash

# Check if any lines in /etc/sudoers or /etc/sudoers.d/* contain "NOPASSWD" (ignoring commented lines)
audit_result=$(grep -r "^[^#].*NOPASSWD" /etc/sudoers*)

# If any such lines are found, the audit fails
if [[ -n "$audit_result" ]]; then
    echo "Audit Failed: The following NOPASSWD entries found in sudoers files:"
    echo "$audit_result"
    echo "Please edit the relevant sudoers file using visudo to remove these entries."
    exit 1
else
    echo "Audit Passed: No NOPASSWD entries found in sudoers files."
    exit 0
fi
```