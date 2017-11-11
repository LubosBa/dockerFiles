# Use Debian stable as the base image
FROM debian:stable

# Workdir
WORKDIR /root/

# Set ups dotdeb repository
RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list

# Downloads repo key
ADD https://www.dotdeb.org/dotdeb.gpg .

# Adds the key into apt
RUN apt-key add dotdeb.gpg

# Updates repo list
RUN apt-get update

# Install nginx from dotdeb
RUN apt-get install nginx -y

# Open up HTTP and HTTPS ports
EXPOSE 80 443

# Setup persistent storage
VOLUME ["/logs", "/www", "/config"]

CMD nginx -g 'daemon off;'
