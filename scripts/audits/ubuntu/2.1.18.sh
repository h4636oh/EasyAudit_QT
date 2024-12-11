#!/bin/bash

# Check if apache2 is installed
if dpkg-query -s apache2 &>/dev/null; then
    echo "apache2 is installed"
else
    echo "apache2 is not installed"
fi

# Check if nginx is installed
if dpkg-query -s nginx &>/dev/null; then
    echo "nginx is installed"
else
    echo "nginx is not installed"
fi

# Check if apache2 or nginx are installed
if dpkg-query -s apache2 &>/dev/null || dpkg-query -s nginx &>/dev/null; then
    # Check if apache2.socket, apache2.service, and nginx.service are enabled
    enabled_services=$(systemctl is-enabled apache2.socket apache2.service nginx.service 2>/dev/null | grep 'enabled')
    if [ -n "$enabled_services" ]; then
        echo "apache2.socket, apache2.service, or nginx.service is enabled:"
        echo "$enabled_services"
        exit 1
    else
        echo "apache2.socket, apache2.service, and nginx.service are not enabled"
    fi

    # Check if apache2.socket, apache2.service, and nginx.service are active
    active_services=$(systemctl is-active apache2.socket apache2.service nginx.service 2>/dev/null | grep '^active')
    if [ -n "$active_services" ]; then
        echo "apache2.socket, apache2.service, or nginx.service is active:"
        echo "$active_services"
        exit 1
    else
        echo "apache2.socket, apache2.service, and nginx.service are not active"
    fi
else
    echo "Neither apache2 nor nginx are installed"
fi

