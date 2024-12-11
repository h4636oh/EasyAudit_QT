
#!/bin/bash

# Audit Script for Ensuring audit configuration files ownership is configured

# Function to check audit configuration files
audit_auditd_files() {
    audit_files=$(find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -user root)
    
    if [ -z "$audit_files" ]; then
        # No files found, audit passes
        echo "Audit configuration files ownership is properly configured."
        exit 0
    else
        # Files found, audit fails
        echo "The following audit configuration files are not owned by the root user:"
        echo "$audit_files"
        echo "Please ensure all these files are owned by the root user and group to pass the audit."
        exit 1
    fi
}

# Execute the audit function
audit_auditd_files
```

