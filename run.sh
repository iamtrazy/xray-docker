#!/bin/sh
/root/env.sh
nohup /usr/local/bin/sing-box -D /var/lib/sing-box -C /etc/sing-box run &>/dev/null &
nohup /usr/bin/caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
