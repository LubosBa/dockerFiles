#!/usr/bin/env bash
# This is an entrypoint of Docker Kibana container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if Kibana config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
  cp -r /opt/kibana/config/* /config/
  # Setup IP address to which Kibana will bind.
  sed -i "s|#server\.host: \"localhost\"|server\.host: \""${IP}"\"|" /config/kibana.yml
  # Setup Kibana name.
  sed -i "s|#server\.name: \"your-hostname\"|server\.name: \"Lubos' Kibana\"|" /config/kibana.yml
  # Setup ElasticSearch connection.
  sed -i "s|#elasticsearch\.url: \"http://localhost:9200\"|elasticsearch\.url: \"http://els1:9200\"|" /config/kibana.yml
fi

/opt/kibana/bin/kibana serve
