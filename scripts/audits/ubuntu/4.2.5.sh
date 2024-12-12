nft list ruleset | grep 'hook input'
type filter hook input priority 0;
nft list ruleset | grep 'hook forward'
type filter hook forward priority 0;
nft list ruleset | grep 'hook output'
type filter hook output priority 0;