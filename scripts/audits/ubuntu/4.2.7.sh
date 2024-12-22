#!/bin/bash

echo "Auditing nftables ruleset for site policy compliance..."

# Function to check rules for incoming connections
check_incoming_rules() {
    echo "Checking rules for established incoming connections..."
    incoming_rules=$(sudo nft list ruleset | awk '/hook input/,/}/' | grep -E 'ip protocol (tcp|udp|icmp) ct state')
    
    if [[ $incoming_rules =~ "ip protocol tcp ct state established accept" && \
          $incoming_rules =~ "ip protocol udp ct state established accept" && \
          $incoming_rules =~ "ip protocol icmp ct state established accept" ]]; then
        echo "PASS: Established incoming connection rules match site policy."
        echo "$incoming_rules"
    else
        echo "FAIL: Established incoming connection rules do not match site policy."
        echo "$incoming_rules"
        exit 1
    fi
}

# Function to check rules for outbound connections
check_outbound_rules() {
    echo "Checking rules for new and established outbound connections..."
    outbound_rules=$(sudo nft list ruleset | awk '/hook output/,/}/' | grep -E 'ip protocol (tcp|udp|icmp) ct state')
    
    if [[ $outbound_rules =~ "ip protocol tcp ct state established,related,new accept" && \
          $outbound_rules =~ "ip protocol udp ct state established,related,new accept" && \
          $outbound_rules =~ "ip protocol icmp ct state established,related,new accept" ]]; then
        echo "PASS: Outbound connection rules match site policy."
        echo "$outbound_rules"
    else
        echo "FAIL: Outbound connection rules do not match site policy."
        echo "$outbound_rules"
        exit 1
    fi
}

# Run checks
check_incoming_rules
check_outbound_rules

echo "Audit completed."
