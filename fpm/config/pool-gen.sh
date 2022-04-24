#!/usr/bin/env sh

echo "[${HOSTNAME}]" >> /config/php-fpm.d/${HOSTNAME}.conf
echo "user = php_web" >> /config/php-fpm.d/${HOSTNAME}.conf
echo "group = php_web" >> /config/php-fpm.d/${HOSTNAME}.conf
echo "listen = 9000" >> /config/php-fpm.d/${HOSTNAME}.conf
echo "pm = dynamic" >> /config/php-fpm.d/${HOSTNAME}.conf
echo "pm.max_children = 5" >> /config/php-fpm.d/${HOSTNAME}.conf
echo "pm.start_servers = 2" >> /config/php-fpm.d/${HOSTNAME}.conf
echo "pm.min_spare_servers = 1" >> /config/php-fpm.d/${HOSTNAME}.conf
echo "pm.max_spare_servers = 3" >> /config/php-fpm.d/${HOSTNAME}.conf
echo "security.limit_extensions = .php .m3u" >> /config/php-fpm.d/${HOSTNAME}.conf