#!/usr/bin/env bash
# This is an entrypoint of Docker Heartbeat container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if ElasticSearch config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
  cp -r /opt/heartbeat/heartbeat.yml /config/
  # Prepare ES configu before startup as this will be first time run.
  # Set shipper name
  sed -i "s/#name:/name: ${HOSTNAME}/" /config/heartbeat.yml
  # Set ES cluster output.
  sed -i 's/hosts: \["localhost:9200"\]/hosts: \["els1:9200"\]/' /config/heartbeat.yml
  # Enable X-Pack monitoring of heartbeat
  sed -i 's|#xpack.monitoring.enabled: false|xpack.monitoring.enabled: true|' /config/heartbeat.yml
  # Set monitoring metrics ES cluster.
  sed -i 's|#xpack.monitoring.elasticsearch:|xpack.monitoring.elasticsearch:|' /config/heartbeat.yml
fi

/opt/heartbeat/heartbeat --path.home /opt/heartbeat/ --path.logs /logs/ --path.data /data/ --path.config /config/ -c /config/heartbeat.yml
