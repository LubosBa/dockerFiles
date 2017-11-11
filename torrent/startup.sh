#!/bin/bash

# Session cleanup
if [[ -f /torrent/data/session/rtorrent.lock ]]; then
  rm /torrent/data/session/rtorrent.lock
fi

# Copies over rtorrent configuration file
if [[ -f /home/torrent/.rtorrent.rc ]]; then
  su -c "screen -dmS rtorrent rtorrent" torrent
fi

# Starts other container processes
nginx -c /etc/nginx/nginx_custom.conf && \
php-fpm7.0 -F -y /etc/php/7.0/fpm/php-fpm_custom.conf
