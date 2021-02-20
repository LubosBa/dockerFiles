#!/usr/bin/env bash
# This is an entrypoint of Docker MetricBeat container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"
MINIO_ROOT_USER="lubos"
MINIO_ROOT_PASSWORD="$(openssl rand -base64 8)"


export IP HOSTNAME MINIO_ROOT_USER MINIO_ROOT_PASSWORD
echo ${MINIO_ROOT_USER} ${MINIO_ROOT_PASSWORD}
/opt/minio server /data