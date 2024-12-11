#!/bin/bash

# Check if autofs is installed
if dpkg-query -s autofs &>/dev/null; then
    echo "autofs is installed"
    
    # Check for packages that depend on autofs
    dependent_packages=$(apt-cache rdepends autofs | grep -v "^ " | grep -v "autofs$")
    if [ -n "$dependent_packages" ]; then
        echo "The following packages depend on autofs:"
        echo "$dependent_packages"
    else
        echo "No packages depend on autofs."
    fi
    
    # Check if autofs.service is enabled
    if systemctl is-enabled autofs.service 2>/dev/null | grep 'enabled'; then
        echo "autofs.service is enabled"
        exit 1
    else
        echo "autofs.service is not enabled"
    fi

    # Check if autofs.service is active
    if systemctl is-active autofs.service 2>/dev/null | grep '^active'; then
        echo "autofs.service is active"
        exit 1
    else
        echo "autofs.service is not active"
    fi
else
    echo "autofs is not installed"
fi

