#!/bin/bash

# Audit script to ensure SNMP services are not in use

# Check if net-snmp package is installed
if rpm -q net-snmp &>/dev/null; then
    echo "FAIL: The net-snmp package is installed."
    exit 1
fi

# Check if snmpd.service is enabled
if systemctl is-enabled snmpd.service 2>/dev/null | grep -q 'enabled'; then
    echo "FAIL: The snmpd.service is enabled."
    exit 1
fi

# Check if snmpd.service is active
if systemctl is-active snmpd.service 2>/dev/null | grep -q '^active'; then
    echo "FAIL: The snmpd.service is active."
    exit 1
fi

echo "PASS: SNMP services are not in use."
exit 0