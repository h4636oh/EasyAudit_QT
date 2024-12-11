#!/bin/bash
if dpkg-query -s telnet &>/dev/null; then;
    echo "telnet is installed"
    exit 1
fi
