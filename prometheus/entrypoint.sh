#!/usr/bin/env bash
# This is an entrypoint of Docker Prometheus container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
#IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
#HOSTNAME="$(hostname -s)"

# Check, if Prometheus config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
    cp -r /opt/prometheus/prometheus.yml /config/
fi


/opt/prometheus/prometheus \
--config.file="/config/prometheus.yml" \
--web.listen-address="0.0.0.0:9090" \
--web.page-title="Lubos' Prometheus Server! Hands off!" \
--storage.tsdb.path="/data/" \
--storage.tsdb.retention.time=104w
