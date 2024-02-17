#!/bin/sh

/usr/local/bin/cloudflared --no-autoupdate tunnel run --token $TOKEN &>/dev/null &

exit