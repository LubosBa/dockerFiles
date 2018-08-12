#!/usr/bin/env bash
# This is an entrypoint of Docker traccar container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if traccar config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
  cp  /opt/traccar/conf/traccar.xml /config/

  # Adjust the location of default config file.
  sed -i "s|\./conf/|/opt/traccar/conf/|" config/traccar.xml


fi

/opt/java/bin/java -jar /opt/traccar/tracker-server.jar /config/traccar.xml
