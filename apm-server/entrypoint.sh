#!/usr/bin/env bash
# This is an entrypoint of Docker ElasticSearch container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"


if [[ -z "$(ls -A /config/)" ]]; then
  cp -r /opt/apm-server/apm-server.yml /config/
  cp -r /opt/apm-server/fields.yml /config/
  cp -r /opt/apm-server/ingest /config/
fi

/opt/apm-server/apm-server --path.config /config/ --path.data /data/ --path.logs /logs/ run
