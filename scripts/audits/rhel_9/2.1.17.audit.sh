#!/bin/bash

# Script to audit if Squid proxy server services are not in use
# Exit with status code 0 if compliant, 1 if not compliant

# Function to check if Squid package is installed
check_squid_installed() {
    if rpm -q squid &> /dev/null; then
        echo "Squid package is installed."
        return 1
    else
        echo "Squid package is not installed."
        return 0
    fi
}

# Function to check if Squid service is enabled
check_squid_service_enabled() {
    if systemctl is-enabled squid.service 2>/dev/null | grep -q 'enabled'; then
        echo "Squid service is enabled."
        return 1
    else
        echo "Squid service is not enabled."
        return 0
    fi
}

# Function to check if Squid service is active
check_squid_service_active() {
    if systemctl is-active squid.service 2>/dev/null | grep -q '^active'; then
        echo "Squid service is active."
        return 1
    else
        echo "Squid service is not active."
        return 0
    fi
}

# Function to prompt for manual verification if required
prompt_manual_verification() {
cat << EOF
If the Squid package is required for dependencies:
- Ensure the dependent package is approved by local site policy.
- Ensure stopping and masking the service and/or socket meets local site policy.
EOF
}

# Main function to orchestrate checks
main() {
    check_squid_installed
    installed_status=$?
    
    if [ $installed_status -eq 0 ]; then
        # The package is not installed, hence compliant
        echo "Audit: **PASS**"
        exit 0
    else
        check_squid_service_enabled
        enabled_status=$?
        
        check_squid_service_active
        active_status=$?
        
        # Both must be not enabled and not active for compliance if installed
        if [ $enabled_status -eq 0 ] && [ $active_status -eq 0 ]; then
            prompt_manual_verification
            # Still compliant if manual verifications are met as per local policy
            echo "Audit: **PASS**"
            exit 0
        else
            echo "Audit: **FAIL**"
            exit 1
        fi
    fi
}

# Run the main function
main
