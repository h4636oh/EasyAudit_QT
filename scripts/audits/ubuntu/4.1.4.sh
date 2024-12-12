#!/usr/bin/env bash
{
    # Run the ufw status verbose command and capture output
    ufw_status_output=$(ufw status verbose)

    # Define the expected rules as an array of strings
    expected_rules=(
        "Anywhere on lo ALLOW IN Anywhere"
        "Anywhere DENY IN 127.0.0.0/8"
        "Anywhere (v6) on lo ALLOW IN Anywhere (v6)"
        "Anywhere (v6) DENY IN ::1"
        "Anywhere ALLOW OUT Anywhere on lo"
        "Anywhere (v6) ALLOW OUT Anywhere (v6) on lo"
    )

    # Check if each expected rule is found in the output
    for rule in "${expected_rules[@]}"; do
        if echo "$ufw_status_output" | grep -q "$rule"; then
            echo "PASS: Rule '$rule' is present."
        else
            echo "FAIL: Rule '$rule' is missing."
        fi
    done
}