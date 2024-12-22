#!/usr/bin/env bash

# Execute ufw status verbose and capture the output
ufw_output=$(ufw status verbose)

# Print the header
echo "To Action From"
echo "-- ------ ----"

# Process and print the rules
echo "$ufw_output" | awk '
/^Anywhere.*on lo\s*ALLOW IN/ { print "Anywhere on lo\tALLOW IN\tAnywhere" }
/^Anywhere\s*DENY IN\s*127\.0\.0\.0\/8/ { print "Anywhere\tDENY IN\t127.0.0.0/8" }
/^Anywhere \(v6\).*on lo\s*ALLOW IN/ { print "Anywhere (v6) on lo\tALLOW IN\tAnywhere (v6)" }
/^Anywhere \(v6\)\s*DENY IN\s*::1/ { print "Anywhere (v6)\tDENY IN\t::1" }
/^Anywhere\s*ALLOW OUT\s*Anywhere on lo/ { print "Anywhere\tALLOW OUT\tAnywhere on lo" }
/^Anywhere \(v6\)\s*ALLOW OUT\s*Anywhere \(v6\) on lo/ { print "Anywhere (v6)\tALLOW OUT\tAnywhere (v6) on lo" }
'

