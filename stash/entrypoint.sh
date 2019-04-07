#!/usr/bin/env bash
# This is an entrypoint of Docker Logstash container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if ElasticSearch config folder is empty:
if [[ -z "$(ls -A /data/)" ]]; then
  mkdir /data/generated
  mkdir /data/metadata
  mkdir /data/cache
fi

/opt/stash/stash-linux
