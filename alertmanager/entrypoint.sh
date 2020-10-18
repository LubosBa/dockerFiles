#!/usr/bin/env bash
# This is an entrypoint of Docker alertmanager container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if alertmanager config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
    cp -r /opt/alertmanager/alertmanager.yml /config/
fi


/opt/alertmanager/alertmanager \
--config.file="/config/alertmanager.yml" \
--web.listen-address="0.0.0.0:9093" \
--storage.path="/data/" \
--data.retention=120h \
--web.external-url="https://amgs1.m8.sk"
