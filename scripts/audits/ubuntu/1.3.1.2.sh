#!/bin/bash

# Function to verify parameter
verify_parameter() {
    local parameter=$1
    local file="/boot/grub/grub.cfg"
    
    if [ ! -f "$file" ]; then
        echo "Error: $file does not exist."
        exit 1
    fi
    
    # Check for the parameter
    result=$(grep "^\s*linux" "$file" | grep -v "$parameter")
    
    if [ -z "$result" ]; then
        echo "All linux lines in $file have the $parameter parameter set."
    else
        echo "The following lines in $file are missing the $parameter parameter:"
        echo "$result"
    fi
}

# Verify apparmor=1 parameter
verify_parameter "apparmor=1"

# Verify security=apparmor parameter
verify_parameter "security=apparmor"

