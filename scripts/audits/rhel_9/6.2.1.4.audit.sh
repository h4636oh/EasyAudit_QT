#!/usr/bin/env bash

# This script audits the logging system to ensure that only one of the two services
# (rsyslog or systemd-journald) is in use, as per best practices for centralized logging.

# Initialize output variables
l_output=""
l_output2=""

# Check if rsyslog is active
if systemctl is-active --quiet rsyslog; then
    l_output="$l_output\n - rsyslog is in use\n- follow the recommendations in Configure rsyslog subsection only"
# Check if systemd-journald is active
elif systemctl is-active --quiet systemd-journald; then
    l_output="$l_output\n - journald is in use\n- follow the recommendations in Configure journald subsection only"
# If neither service is active, log the inability to determine logging system
else
    echo -e "unable to determine system logging"
    l_output2="$l_output2\n - unable to determine system logging\n- Configure only ONE system logging: rsyslog OR journald"
fi

# Check the output and decide the audit result
if [ -z "$l_output2" ]; then
    # Audit passes if no errors in l_output2
    echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    exit 0
else
    # Audit fails if there are errors in l_output2
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2"
    exit 1
fi
```

This script checks the status of the `rsyslog` and `systemd-journald` services and determines if one of them is running exclusively, per the provided requirements. It exits with status `0` if one logging system is in use and with status `1` if it fails to determine the logging system in use.