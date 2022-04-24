# Use Alpine Latest as the base image
FROM alpine:latest

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Set up packages
RUN apk update && apk upgrade; \
apk add php8 php8-fpm; \
apk search php8 | awk -F'-' '{print $1"-"$2}' | grep -vE 'pecl|php8-8' | xargs apk add; \
adduser -h /opt/ -s /bin/sh -u 9999 -D php_web; \
mkdir -p /config;

# Add startup script.
ADD entrypoint.sh .

# Add script for generating PHP-FPM pool
ADD config/pool-gen.sh .

# Add PHP-FPM config
ADD config/php-fpm.conf .

RUN chmod +x /opt/entrypoint.sh; \
chmod +x /opt/pool-gen.sh; \
chown -R 9999:9999 /config;

VOLUME ["/logs", "/www", "/config"]

# Starts PHP-FPM
CMD /opt/entrypoint.sh