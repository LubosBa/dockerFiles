#!/usr/bin/env sh
# This is an entrypoint of Docker nginx container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# nginx.conf location
DEFAULT_CONFIG='/config/nginx.conf'
DEFAULT_SERVER='/config/http.d/default.conf'

# Generate default minimal nginx.conf file.
generateConfig()
{
  # Check, if there is default config & delete it.
  #if [ -f "/config/nginx.conf" ]; then
  #  rm /config/nginx.conf
  #fi

cat <<'EOF'
# Default Process Configuration
user nginx;
worker_processes auto;
pcre_jit on;
pid /run/nginx.pid;
error_log /logs/error.log;
include /config/modules/*.conf;
daemon off;

# Connection handling
events {
  worker_connections 4096;
  use epoll;
  multi_accept on;
}

# Default http handling
http {
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  server_tokens off;
  disable_symlinks if_not_owner;
  charset utf-8;
  server_names_hash_bucket_size 64;
  #server_name_in_redirect off;

  reset_timedout_connection on;
  client_max_body_size 20m;

  include /config/mime.types;
  default_type application/octet-stream;

  ##
  # Proxy
  ##
  real_ip_header X-Forwarded-For;
  real_ip_recursive on;

  ##
  # Logging Settings
  ##

  access_log /logs/access.log;
  error_log /logs/error.log;

  log_format merged '$remote_addr $host $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent" '
		                'rt=$request_time uct="$upstream_connect_time" uht="$upstream_header_time" urt="$upstream_response_time" '
                    '$ssl_protocol $ssl_cipher';

  #Logstash
  access_log /logs/access_merged.log merged;
  
  ##
  # Gzip Settings
  ##

  gzip on;
  #brotli on;
  gzip_disable "msie6";
  gzip_static on;
  gzip_min_length 1400;
  gzip_vary on;
  gzip_comp_level 9;
  gzip_buffers 16 8k;
  gzip_http_version 1.1;
  gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript image/png image/gif image/jpeg image/svg+xml;

  ##
  # File includes for server configs
  ##

  include /config/http.d/*;
}
EOF
}

generateDefaultServer()
{
cat <<'EOF'
server {
  listen 80 default_server;

  # Return Hello
  location / {
    add_header Content-Type text/html;
    return 200 '<html><body>Hello World</body></html>';
  }
}
EOF
}

# Check, if nginx config folder is empty:
if [[ -z "$(ls -A /config/)" ]]; then
  # Copy default nginx config.
  cp -r /etc/nginx/* /config/
  generateConfig > $DEFAULT_CONFIG
  generateDefaultServer > $DEFAULT_SERVER
fi

/usr/sbin/nginx -c /config/nginx.conf
