#!/usr/bin/env bash
# This is an entrypoint of Docker Ghost container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if Ghost config folder is empty:
if [[ ! -f "/config/config.production.json" ]]; then
   # Setup env for npm.
   PATH="${PATH}:/opt/node/bin"
   export PATH
   
   # Install Ghost dependencies.
   cd /opt/ghost; npm install --production
   
   # Copy default configuration file to /conf folder so it's editable.
   cp /opt/ghost/core/server/config/env/config.production.json /config/config.production.json
fi

PATH="${PATH}:/opt/node/bin"
export PATH
export NODE_ENV=production

/opt/node/bin/node /opt/ghost/index.js
