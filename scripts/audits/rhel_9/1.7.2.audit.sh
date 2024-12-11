#!/bin/bash

# This script audits the content of /etc/issue to ensure
# it complies with site-specific policies and does not disclose
# unnecessary system information.

# Function to check and print the contents of /etc/issue
check_issue_content() {
    echo "Checking the contents of /etc/issue..."
    cat /etc/issue

    echo ""
    echo "Please manually verify that the above contents match your site policy."
}

# Function to search for unwanted patterns in /etc/issue
check_unwanted_patterns() {
    echo "Checking for unwanted patterns in /etc/issue..."
    system_info=$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g')

    # Check for patterns related to machine architecture, OS release, name, and version
    results=$(grep -E -i "(\\\\v|\\\\r|\\\\m|\\\\s|$system_info)" /etc/issue)

    if [ -z "$results" ]; then
        echo "No unwanted patterns found in /etc/issue. Audit passed."
        return 0
    else
        echo "Unwanted patterns detected in /etc/issue:"
        echo "$results"
        echo "Please update the /etc/issue file as per your site policy."
        return 1
    fi
}

# Main execution starts here
check_issue_content
if check_unwanted_patterns; then
    echo "Audit: passed."
    exit 0
else
    echo "Audit: failed."
    exit 1
fi