#!/usr/bin/env bash
# This is an entrypoint of Docker Prometheus container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if Grafana config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
    cp -r /opt/grafana/conf/* /config/
    # Adjust default configurations
    sed -i 's|data = data|data = /data|' /config/defaults.ini
    sed -i 's|logs = data/log|logs = /logs|' /config/defaults.ini
    sed -i 's|plugins = data/plugins|plugins = /data/plugins|' /config/defaults.ini
    sed -i 's|provisioning = conf/provisioning|provisioning = /config/provisionings|' /config/defaults.ini
fi


/opt/grafana/bin/grafana-server \
-homepath /opt/grafana \
-config /config/defaults.ini