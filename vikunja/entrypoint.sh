#!/usr/bin/env sh
# This is an entrypoint of Docker Vikunja container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"


/opt/vikunja/vikunja-v0.18.1-linux-amd64
