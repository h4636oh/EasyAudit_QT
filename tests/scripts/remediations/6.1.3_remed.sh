#!/bin/bash

# Function to add or update lines in aide.conf
update_aide_conf() {
    local config_file="/etc/aide/aide.conf"
    local audit_tools=(
        "/sbin/auditctl p+i+n+u+g+s+b+acl+xattrs+sha512"
        "/sbin/auditd p+i+n+u+g+s+b+acl+xattrs+sha512"
        "/sbin/ausearch p+i+n+u+g+s+b+acl+xattrs+sha512"
        "/sbin/aureport p+i+n+u+g+s+b+acl+xattrs+sha512"
        "/sbin/autrace p+i+n+u+g+s+b+acl+xattrs+sha512"
        "/sbin/augenrules p+i+n+u+g+s+b+acl+xattrs+sha512"
    )
    
    echo "Updating $config_file with audit tool selection lines..."
    
    for line in "${audit_tools[@]}"; do
        if grep -qF "$line" "$config_file"; then
            echo "Line already exists: $line"
        else
            echo "$line" | sudo tee -a "$config_file"
        fi
    done
    
    echo "Checking for @@x_include statements..."
    if grep -q "^@@x_include" "$config_file"; then
        echo "@@x_include statement found in $config_file. Please ensure the included files are executable and meet the required security criteria."
    else
        echo "No @@x_include statements found."
    fi
}

# Execute the function
update_aide_conf

