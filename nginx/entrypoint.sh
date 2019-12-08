#!/usr/bin/env bash
# This is an entrypoint of Docker nginx container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if nginx config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
  # Copy default nginx config.
  cp -r /etc/nginx/* /config/
  # Make sure that the process doesn't go to background after startup.
  sed -i '1 i\daemon off;' /config/nginx.conf
fi

/usr/sbin/nginx -c /config/nginx.conf
