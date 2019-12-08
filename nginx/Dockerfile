# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Updates repo list
RUN apt-get update

# Install nginx from dotdeb
RUN apt-get install nginx -y

# Open up HTTP and HTTPS ports
EXPOSE 80 443

# Setup persistent storage
VOLUME ["/logs", "/www", "/config"]

# Starts nginx
CMD /opt/entrypoint.sh