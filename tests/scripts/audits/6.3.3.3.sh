#!/bin/bash

# Check on-disk rules
echo "Checking on-disk rules:"
SUDO_LOG_FILE=$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g' -e 's|/|\\/|g')
if [ -n "${SUDO_LOG_FILE}" ]; then
    on_disk_rules=$(awk "/^ *-w/ && /${SUDO_LOG_FILE}/ && / +-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/" /etc/audit/rules.d/*.rules)
    if [ "$on_disk_rules" == "-w /var/log/sudo.log -p wa -k sudo_log_file" ]; then
        echo "On-disk rules match expected values."
    else
        echo "On-disk rules do not match expected values:"
        echo "$on_disk_rules"
        exit 1
    fi
else
    echo "ERROR: Variable 'SUDO_LOG_FILE' is unset."
fi

# Check running configuration rules
echo "Checking running configuration rules:"
SUDO_LOG_FILE=$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g' -e 's|/|\\/|g')
if [ -n "${SUDO_LOG_FILE}" ]; then
    running_rules=$(auditctl -l | awk "/^ *-w/ && /${SUDO_LOG_FILE}/ && / +-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/")
    if [ "$running_rules" == "-w /var/log/sudo.log -p wa -k sudo_log_file" ]; then
        echo "Running configuration rules match expected values."
    else
        echo "Running configuration rules do not match expected values:"
        echo "$running_rules"
        exit 1
    fi
else
    echo "ERROR: Variable 'SUDO_LOG_FILE' is unset."
fi

