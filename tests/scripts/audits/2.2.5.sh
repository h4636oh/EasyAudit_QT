#!/bin/bash
if dpkg-query -s ldap-utils &>/dev/null; then 
    echo "ldap-utils is installed" 
    exit 1
fi
