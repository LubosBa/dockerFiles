#!/usr/bin/env bash
# This is an entrypoint of Docker PHP-FPM container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if FPM config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
    # Create basic folder structure.
    mkdir -p /config/{fpm/pool.d,fpm/conf.d,phpdbg}
    # Copy PHP-FPM configuration.
    cp /etc/php/7.3/mods-available/* /config/fpm/conf.d/
    # Delete default configuration of PHP.
    rm -rf /etc/php/7.3/mods-available && rm -rf /etc/php/7.3/fpm/conf.d
    # Create a sym link for PHP-FPM module loading.
    ln -s /config/fpm/conf.d /etc/php/7.3/fpm/conf.d

    # Copy default php.ini.
    cp /etc/php/7.3/fpm/php.ini /config/php.ini

    # Generate php-fpm.conf file.
    echo "[global]" >> /config/fpm/php-fpm.conf
    echo "pid = /tmp/php-fpm.pid" >> /config/fpm/php-fpm.conf
    echo "error_log = /logs/php-fpm.log" >> /config/fpm/php-fpm.conf
    echo "include=/config/fpm/pool.d/*.conf" >> /config/fpm/php-fpm.conf

    # Generate FPM pool configuration.
    echo "[${HOSTNAME}]" >> /config/fpm/pool.d/${HOSTNAME}.conf
    echo "user = php_web" >> /config/fpm/pool.d/${HOSTNAME}.conf
    echo "group = php_web" >> /config/fpm/pool.d/${HOSTNAME}.conf
    echo "listen = 9000" >> /config/fpm/pool.d/${HOSTNAME}.conf
    echo "pm = dynamic" >> /config/fpm/pool.d/${HOSTNAME}.conf
    echo "pm.max_children = 5" >> /config/fpm/pool.d/${HOSTNAME}.conf
    echo "pm.start_servers = 2" >> /config/fpm/pool.d/${HOSTNAME}.conf
    echo "pm.min_spare_servers = 1" >> /config/fpm/pool.d/${HOSTNAME}.conf
    echo "pm.max_spare_servers = 3" >> /config/fpm/pool.d/${HOSTNAME}.conf
    echo "security.limit_extensions = .php .m3u" >> /config/fpm/pool.d/${HOSTNAME}.conf
fi

# Start FPM-Pool
/usr/sbin/php-fpm7.3 -F -y /config/fpm/php-fpm.conf -c /config/php.ini



