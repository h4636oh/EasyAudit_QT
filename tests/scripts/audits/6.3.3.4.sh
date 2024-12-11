#!/bin/bash

# Function to check on-disk rules
check_on_disk_rules() {
    echo "Checking on-disk rules:"
    on_disk_rules=$(awk '/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && / -S/ && (/adjtimex/ || /settimeofday/ || /clock_settime/) && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/' /etc/audit/rules.d/*.rules)
    on_disk_localtime=$(awk '/^ *-w/ && /\/etc\/localtime/ && / +-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/' /etc/audit/rules.d/*.rules)
    
    echo "$on_disk_rules"
    echo "$on_disk_localtime"
}

# Function to check running configuration rules
check_running_rules() {
    echo "Checking running configuration rules:"
    running_rules=$(auditctl -l | awk '/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && / -S/ && (/adjtimex/ || /settimeofday/ || /clock_settime/) && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/')
    running_localtime=$(auditctl -l | awk '/^ *-w/ && /\/etc\/localtime/ && / +-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/')

    echo "$running_rules"
    echo "$running_localtime"
}

# Run the checks
check_on_disk_rules
check_running_rules

