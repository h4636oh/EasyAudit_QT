#!/bin/bash

# This script audits the configuration of log rotation for rsyslog.
# It checks if logs are rotated according to site policy as outlined in logrotate configuration files.
# Note: This script is intended for systems where rsyslog is used for logging, not for systems using systemd-journald.

# Verify if systemd-journal-upload.service is active, in which case rsyslog logrotate configuration is not applicable.
if systemctl is-active --quiet systemd-journal-upload.service; then
    echo -e "- journald is in use on the system\n- recommendation is not applicable (NA)"
    exit 0
fi

# Variable to hold the output for audit results
l_output=""
l_rotate_conf=""

# Check if /etc/logrotate.conf exists
if [ -f /etc/logrotate.conf ]; then
    l_rotate_conf="/etc/logrotate.conf"
    
    # Additional check for individual configuration files in /etc/logrotate.d/
    if compgen -G "/etc/logrotate.d/*.conf" > /dev/null; then
        echo "- Found additional logrotate configurations under /etc/logrotate.d/"
    fi
else
    # Check if there are configurations in /etc/logrotate.d/
    if compgen -G "/etc/logrotate.d/*.conf" > /dev/null; then
        for file in /etc/logrotate.d/*.conf; do
            l_rotate_conf="${l_rotate_conf}\n$file"
        done
    else
        # If neither exists, logrotate is not configured
        l_output="$l_output\n- rsyslog is in use and logrotate is not configured"
    fi
fi

# Decide the output based on findings
if [ -z "$l_output" ]; then
    echo -e "\n- Audit Result:\n** REVIEW **\n- Please review $l_rotate_conf and verify logs are rotated according to site policy."
    exit 0
else
    echo -e "\n- Audit Result:\n** FAIL **\n- Reason(s) for audit failure:\n$l_output"
    exit 1
fi
```

This script audits the logrotate configuration and checks if it's set up properly when rsyslog is the logging method being employed. It verifies configuration files in `/etc/logrotate.conf` and `/etc/logrotate.d/`. A manual review is suggested when configuration files are found, while it reports a failure if no configuration for logrotate is detected when rsyslog is in use. It also checks if journald is used instead, in which case the audit is non-applicable.