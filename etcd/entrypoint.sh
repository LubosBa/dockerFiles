#!/usr/bin/env bash
# This is an entrypoint of Docker etcd container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

if [[ ! -f /config/etcd.yml ]]
then
    echo "No etcd.yml file in /config/ folder! Please provide config"
    exit 1
fi

export IP HOSTNAME
/opt/etcd/etcd --config-file /config/etcd.yml