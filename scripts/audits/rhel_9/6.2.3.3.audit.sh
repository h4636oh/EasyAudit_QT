#!/bin/bash

# This script audits if journald is configured to send logs to rsyslog
# It will exit with status 0 if the audit passes and status 1 if it fails.

# Check ForwardToSyslog configuration in systemd-journald
AUDIT_RESULT=$(systemd-analyze cat-config systemd/journald.conf systemd/journald.conf.d/* | grep -E "^ForwardToSyslog=yes")

if [[ -n "$AUDIT_RESULT" ]]; then
    echo "Pass: ForwardToSyslog is set to yes. Logs are being forwarded to rsyslog."
    exit 0
else
    echo "Fail: ForwardToSyslog is not set to yes. Logs are not being forwarded to rsyslog."
    echo "Please configure ForwardToSyslog to yes in /etc/systemd/journald.conf or corresponding file in /etc/systemd/journald.conf.d/"
    exit 1
fi
```

#This script checks if systemd-journald is configured to forward logs to rsyslog by verifying if `ForwardToSyslog=yes` is present in the configuration. If the setting is correct, it outputs a pass result and exits with status 0. If not, it prompts the user to manually configure it and exits with status 1.