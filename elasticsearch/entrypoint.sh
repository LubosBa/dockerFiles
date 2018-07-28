#!/usr/bin/env bash
# This is an entrypoint of Docker ElasticSearch container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if ElasticSearch config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
  cp -r /opt/elasticsearch/config/* /config/
  # Prepare ES configu before startup as this will be first time run.
  # Set cluster name.
  sed -i 's/#cluster.name: my-application/cluster.name: es-hertzner/' /config/elasticsearch.yml
  # Set node name based on container hostname.
  sed -i "s/#node.name: node-1/node.name: ${HOSTNAME}/" /config/elasticsearch.yml
  # Set data path.
  sed -i 's|#path.data: /path/to/data|path.data: /data|' /config/elasticsearch.yml
  # Set log path.
  sed -i 's|#path.logs: /path/to/logs|path.logs: /logs|' /config/elasticsearch.yml
  # Setup network address to which ES will bind.
  sed -i "s/#network.host: 192.168.0.1/network.host: ${IP}/" /config/elasticsearch.yml

fi

/opt/elasticsearch/bin/elasticsearch
