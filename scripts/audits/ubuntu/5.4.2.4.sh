passwd -S root | awk '$2 ~ /^P/ {print "User: \"" $1 "\" Password is set"}'
User: "root" Password is set