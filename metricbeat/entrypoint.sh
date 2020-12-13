#!/usr/bin/env bash
# This is an entrypoint of Docker MetricBeat container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if MetricBeat config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
    cp /opt/metricbeat/metricbeat-7.10.1-linux-x86_64/*.yml /config/
    cp -r /opt/metricbeat/metricbeat-7.10.1-linux-x86_64/modules.d /opt/metricbeat/metricbeat-7.10.1-linux-x86_64/module /opt/metricbeat/metricbeat-7.10.1-linux-x86_64/kibana /config/
fi

if [[ ! -f /config/metricbeat.yml ]]
then
    echo "No filebeat.yml file in /config/ folder! Please provide config"
    exit 1
fi

/opt/metricbeat/metricbeat-7.10.1-linux-x86_64/metricbeat run --path.config /config --path.data /data --path.logs /logs --system.hostfs /hostfs