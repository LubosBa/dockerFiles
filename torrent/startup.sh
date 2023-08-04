#!/bin/bash

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"

# Get external IP of the maichine.
EXT_IP="$(curl -s zx2c4.com/ip | head -1)"

# Check, if rtorrent config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
    cp /home/torrent/.rtorrent.rc /config/rtorrent.rc
fi

# Session cleanup
if [[ -f /data/session/rtorrent.lock ]]; then
  rm /data/session/rtorrent.lock
fi

## Copies over rtorrent configuration file
#if [[ -f /home/torrent/.rtorrent.rc ]]; then
#  su -c "screen -dmS rtorrent rtorrent" torrent
#fi

# Starts other container processes
nginx -c /etc/nginx/nginx_custom.conf && \
php-fpm7.4 -D -y /etc/php/7.4/fpm/php-fpm_custom.conf && \
su -c "/usr/bin/rtorrent -n -i ${EXT_IP} -o import=/config/rtorrent.rc" torrent