#!/bin/bash

# Check if sudo is installed
dpkg-query -s sudo &>/dev/null && echo "sudo is installed" && exit 1

# Check if sudo-ldap is installed
dpkg-query -s sudo-ldap &>/dev/null && echo "sudo-ldap is installed" && exit 1

