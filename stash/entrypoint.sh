#!/usr/bin/env bash
# This is an entrypoint of Docker Logstash container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if ElasticSearch config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
  cp -r /opt/logstash/config/* /config/
  mkdir -p /config/pipeline
  # Set node name.
  sed -i "s|# node\.name: test|node.name: ${HOSTNAME}|" /config/logstash.yml
  # Set data folder.
  sed -i "s|# path\.data:|path\.data: /data/|" /config/logstash.yml
  # Set pipeline config directory.
  sed -i "s|# path\.config:|path\.config: /config/pipeline/*.conf|" /config/logstash.yml
  # Set bind address for LS metrics.
  sed -i "s|# http\.host: \"127\.0\.0\.1\"|http\.host: \""${IP}"\"|" /config/logstash.yml
  # Set log folder.
  sed -i "s|# path\.logs:|path\.logs: /logs/|" /config/logstash.yml

fi

/opt/logstash/bin/logstash
