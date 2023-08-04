#!/usr/bin/env sh
# This is an entrypoint of Docker PHP-FPM container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
export HOSTNAME="$(hostname -s)"

# Check, if FPM config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
    # Create basic folder structure.
    mkdir -p /config/php-fpm.d /config/conf.d
    # Copy PHP-FPM configuration.
    cp /etc/php8/conf.d/* /config/conf.d/
    # Delete default configuration of PHP.
    rm -rf /etc/php8/conf.d
    # Create a sym link for PHP-FPM module loading.
    ln -s /config/conf.d /etc/php8/conf.d

    # Copy default php.ini.
    cp /etc/php8/php.ini /config/php.ini

    # Move PHP-FPM config
    mv /opt/php-fpm.conf /config/

    # Generate FPM pool configuration.
    /opt/pool-gen.sh
fi

# Start FPM-Pool
/usr/sbin/php-fpm* -F -y /config/php-fpm.conf -c /config/php.ini



