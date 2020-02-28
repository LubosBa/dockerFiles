#!/usr/bin/env bash
# This is an entrypoint of Docker ZooKeeper container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if ZooKeeper config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
    cp -r /opt/apache-zookeeper-3.5.7-bin/conf/* /config/
fi

if [[ ! -f /config/zoo.cfg ]]
then
    echo "No zoo.cfg file in /config/ folder! Please provide config"
    exit 1
fi

/opt/apache-zookeeper-3.5.7-bin/bin/zkServer.sh --config /config/