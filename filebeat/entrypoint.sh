#!/usr/bin/env bash
# This is an entrypoint of Docker FileBeat container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if FileBeat config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
    cp /opt/filebeat/*.yml /config/
    cp -r /opt/filebeat/kibana /opt/filebeat/module /opt/filebeat/modules.d /config/ 
fi

if [[ ! -f /config/filebeat.yml ]]
then
    echo "No filebeat.yml file in /config/ folder! Please provide config"
    exit 1
fi

/opt/filebeat/filebeat run --path.config /config --path.data /data --path.logs /logs