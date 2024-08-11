#!/usr/bin/env sh
# This is an entrypoint of Docker nginx container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# nginx.conf location
DEFAULT_CONFIG='/config/nginx.conf'
DEFAULT_SERVER='/config/http.d/default.conf'

# Certbot configuration
LE_FOLDER='/config/le_certs'
CHECK_PERIOD="1d"

# Check, if nginx config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
  # Copy default nginx config.
  cp -r /etc/nginx/* /config/
  cp /opt/nginx.conf "$DEFAULT_CONFIG"
  cp /opt/default.conf "$DEFAULT_SERVER"

  for dir in csr pkey certs conf fullchain; do
    mkdir -p ${LE_FOLDER}/${dir}
  done
fi

function currentDate() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Init automatic cert renewal
if [ "${LETSENCRYPT}" != "true" ]; then
  echo "[$(currentDate)] Let's encrypt automatic updater disabled. Starting nginx..."
  /usr/sbin/nginx -c ${DEFAULT_CONFIG}
else
  (
      echo "[$(currentDate)] Starting Let's encrypt updater loop."
      sleep 5 # Give 5 seconds time for nginx startup.
      while :; do
        echo "[$(currentDate)] Checking certificates for ${LE_FQDN}"
        /opt/le_cert_get.sh
        
        echo "[$(currentDate)] Reloading nginx with new SSL Certificates"
        /usr/sbin/nginx -c ${DEFAULT_CONFIG} -s reload
        if [ $? -ne 0 ]; then
            echo "[$(currentDate)] nginx reload failed! Check error logs."
        else
            echo "[$(currentDate)] nginx reload successful! Next run will take place in ${CHECK_PERIOD}"
        fi
        sleep ${CHECK_PERIOD}
      done
  ) &
  /usr/sbin/nginx -c ${DEFAULT_CONFIG}
fi