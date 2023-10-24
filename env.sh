#!/bin/sh
source .env

# Check if UUID is set in the .env file
if [ -z "$UUID" ]; then
  echo "UUID is not set"
  exit 1
fi

sed -i "s/\$UUID/$UUID/g" /etc/sing-box/config.json
