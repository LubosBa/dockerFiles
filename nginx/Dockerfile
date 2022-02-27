# Use Debian stable as the base image
FROM alpine:latest

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Add startup script.
ADD entrypoint.sh .

# Add default nginx config
ADD config/nginx.conf .

# Add default vhost config.
ADD config/default.conf .

# Updates repo list & install nginx
RUN apk --no-cache add nginx

# Make startup script executable.
RUN chmod +x /opt/entrypoint.sh

# Open up HTTP and HTTPS ports
EXPOSE 80 443

# Setup persistent storage
VOLUME ["/logs", "/www", "/config"]

# Starts nginx
CMD /opt/entrypoint.sh