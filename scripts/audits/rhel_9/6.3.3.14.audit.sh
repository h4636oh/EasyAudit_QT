#!/bin/bash

# Function to perform the audit task for SELinux directory monitoring
audit_selinux_monitoring() {
    local audit_file_output
    local auditctl_output

    # Check on-disk configuration
    audit_file_output=$(awk '/^ *-w/ &&(/\/etc\/selinux/ ||/\/usr\/share\/selinux/) &&/ +-p *wa/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    # Expected output for on-disk configuration
    local expected_on_disk="-w /etc/selinux -p wa -k MAC-policy
-w /usr/share/selinux -p wa -k MAC-policy"

    # Check running configuration
    auditctl_output=$(auditctl -l | awk '/^ *-w/ &&(/\/etc\/selinux/ ||/\/usr\/share\/selinux/) &&/ +-p *wa/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)')

    # Verify the outputs
    if [[ "$audit_file_output" != "$expected_on_disk" ]] || [[ "$auditctl_output" != "$expected_on_disk" ]]; then
        echo "Audit failed: The SELinux monitoring configuration does not meet the requirements."
        echo "Please ensure the following rules are present in your audit configuration:"
        echo "$expected_on_disk"
        exit 1
    fi

    echo "Audit passed: The SELinux monitoring configuration is correct."
    exit 0
}

# Run the audit function
audit_selinux_monitoring
