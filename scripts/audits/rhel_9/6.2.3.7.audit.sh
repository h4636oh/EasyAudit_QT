
#!/bin/bash

# Audit script to ensure that rsyslog is not configured to receive logs from a remote client.

# Check for the presence of configurations that enable rsyslog to accept incoming logs.
# Verify both advanced format and deprecated legacy format.

# Perform audit in advanced format
adv_modload=$(grep -Psi -- '^\h*module\(load="imtcp"\)' /etc/rsyslog.conf /etc/rsyslog.d/*.conf)
adv_input=$(grep -Psi -- '^\h*input\(type="imtcp"\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf)

# Perform audit in deprecated legacy format
legacy_modload=$(grep -Psi -- '^\h*\$ModLoad\h+imtcp\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf)
legacy_input=$(grep -Psi -- '^\h*\$InputTCPServerRun\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf)

# Check for any findings
if [[ -n "$adv_modload" || -n "$adv_input" || -n "$legacy_modload" || -n "$legacy_input" ]]; then
    echo "Audit failed: rsyslog is configured to receive logs from remote clients."
    echo "Please check the configuration files:"
    [[ -n "$adv_modload" ]] && echo "- Advanced Format Module Load found in: $adv_modload"
    [[ -n "$adv_input" ]] && echo "- Advanced Format Input found in: $adv_input"
    [[ -n "$legacy_modload" ]] && echo "- Legacy Format ModLoad found in: $legacy_modload"
    [[ -n "$legacy_input" ]] && echo "- Legacy Format InputTCPServerRun found in: $legacy_input"
    echo "Please manually remove these configurations as instructed in the Remediation section."
    exit 1
else
    echo "Audit passed: rsyslog is not configured to receive logs from remote clients."
    exit 0
fi
```