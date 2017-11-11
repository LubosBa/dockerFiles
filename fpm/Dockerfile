# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /root/

# Set ups dotdeb repository
RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list; \
echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list

# Downloads repo key
ADD https://www.dotdeb.org/dotdeb.gpg .

# Adds the key into apt and install php
RUN apt-key add dotdeb.gpg; \
apt-get update && apt-get install -y \
   php7.0 \
   php7.0-bcmath \
   php7.0-bz2 \
   php7.0-cli \
   php7.0-common \
   php7.0-curl \
   php7.0-dba \
   php7.0-dbg \
   php7.0-dev \
   php7.0-enchant \
   php7.0-fpm \
   php7.0-gd \
   php7.0-geoip \
   php7.0-gmp \
   php7.0-igbinary \
   php7.0-imagick \
   php7.0-imap \
   php7.0-interbase \
   php7.0-intl \
   php7.0-json \
   php7.0-ldap \
   php7.0-mbstring \
   php7.0-mcrypt \
   php7.0-memcached \
   php7.0-mongodb \
   php7.0-msgpack \
   php7.0-mysql \
   php7.0-odbc \
   php7.0-opcache \
   php7.0-pgsql \
   php7.0-phpdbg \
   php7.0-pspell \
   php7.0-readline \
   php7.0-recode \
   php7.0-redis \
   php7.0-soap \
   php7.0-sqlite3 \
   php7.0-ssh2 \
   php7.0-sybase \
   php7.0-tidy \
   php7.0-xdebug \
   php7.0-xml \
   php7.0-xmlrpc \
   php7.0-xsl \
   php7.0-zip \
&& rm -rf /var/lib/apt/lists/*

# Creates unpriviledged user
RUN useradd -u 9999 --shell /bin/bash php_web

# Deletes extension configuration
RUN rm -rf /etc/php/7.0/mods-available/

# Creates a symlink to extension configuration
RUN ln -s /config/mods-available /etc/php/7.0/mods-available

# Setup persistent storage
VOLUME ["/logs", "/www", "/config"]

# Change user to elastic user.
USER php_web


CMD php-fpm7.0 -F -y /config/fpm/php-fpm.conf -c /config/php.ini