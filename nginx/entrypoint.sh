#!/usr/bin/env sh
# This is an entrypoint of Docker nginx container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# nginx.conf location
DEFAULT_CONFIG='/config/nginx.conf'
DEFAULT_SERVER='/config/http.d/default.conf'

# Check, if nginx config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
  # Copy default nginx config.
  cp -r /etc/nginx/* /config/
  cp /opt/nginx.conf "$DEFAULT_CONFIG"
  cp /opt/default.conf "$DEFAULT_SERVER"
fi

/usr/sbin/nginx -c /config/nginx.conf
