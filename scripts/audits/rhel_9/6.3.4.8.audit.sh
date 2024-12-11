
#!/usr/bin/env bash

# Profile Applicability:
# • Level 2 - Server
# • Level 2 - Workstation
#
# Description:
# Audit tools include, but are not limited to, vendor-provided and open source audit tools needed 
# to successfully view and manipulate audit information system activity and records.
#
# Rationale:
# Protecting audit information includes identifying and protecting the tools used to view and manipulate
# log data. Protecting audit tools is necessary to prevent unauthorized operation on audit information.

# Define variables for audit
permission_mask="0022"
max_permissible_mode=$(printf '%o' $(( 0777 & ~$permission_mask )))
audit_tools=(
    "/sbin/auditctl"
    "/sbin/aureport"
    "/sbin/ausearch"
    "/sbin/autrace"
    "/sbin/auditd"
    "/sbin/augenrules"
)

audit_failed=false
output_correct=""
output_incorrect=""

# Audit loop for each tool
for tool in "${audit_tools[@]}"; do
    if [ ! -f "$tool" ]; then
        echo "Warning: Audit tool $tool does not exist on this system. Skipping."
        continue
    fi

    current_mode=$(stat -Lc '%#a' "$tool")

    if [ $((current_mode & permission_mask)) -gt 0 ]; then
        # Tool is not correctly configured
        audit_failed=true
        output_incorrect+="\n - Audit tool \"$tool\" is mode: \"$current_mode\" and should be mode: \"$max_permissible_mode\" or more restrictive"
    else
        # Tool is correctly configured
        output_correct+="\n - Audit tool \"$tool\" is correctly configured to mode: \"$current_mode\""
    fi
done

# Display audit results
if [ "$audit_failed" = false ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured *\n:$output_correct"
    exit 0
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$output_incorrect\n"
    [ -n "$output_correct" ] && echo -e "\n - * Correctly configured *\n:$output_correct\n"
    exit 1
fi
```

This script checks the permissions of specified audit tools to ensure they are configured with the correct file mode, as defined by the mask `0022`. If any tool's mode is found to be less restrictive than the recommended settings, the script logs this and exits with a failure status. In case of no discrepancies, it logs a success message. It also skips any tools that do not exist on the system, issuing a warning for these cases.