#!/bin/bash
if dpkg-query -s ftp &>/dev/null; then
    echo "ftp is installed"
    exit 1
fi
