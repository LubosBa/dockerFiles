# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Installs fpm and rtorrent
RUN apt-get update && apt-get install -y \
   php-fpm \
   rtorrent \
   screen \
   nginx \
   curl mediainfo sox unzip python ffmpeg \
&& rm -rf /var/lib/apt/lists/*

# Container cleanup
RUN rm /etc/php/7.3/fpm/pool.d/www.conf; \
    rm /etc/php/7.3/fpm/php-fpm.conf; \
    rm /etc/nginx/nginx.conf; \
    rm /etc/nginx/sites-enabled/default; \
    mkdir /www; mkdir -p /home/torrent

# Configuration setup
COPY php-fpm.conf /etc/php/7.3/fpm/php-fpm_custom.conf
COPY torrent_fpm.conf /etc/php/7.3/fpm/pool.d/torrent.conf
COPY nginx.conf /etc/nginx/nginx_custom.conf
COPY torrent_nginx.conf /etc/nginx/sites-enabled/torrent
COPY rutorrent/ /www/
COPY rtorrent.rc /home/torrent/.rtorrent.rc
COPY startup.sh /startup.sh

# Creates unpriviledged user
RUN useradd -u 9999 --shell /bin/bash torrent; \
    chown -R torrent:torrent /www; \
    chown -R torrent:torrent /home/torrent

# Setup persistent storage
VOLUME ["/logs", "/torrent", "/config" ]

CMD /startup.sh
