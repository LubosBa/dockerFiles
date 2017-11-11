# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /app/

# Install dependencies for MariaDB
RUN apt-get update && apt-get install -y \
   software-properties-common \
   apt-transport-https; \
   apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db; \
   add-apt-repository 'deb [arch=amd64,i386,ppc64el] https://mirror.herrbischoff.com/mariadb/repo/10.2/debian jessie main'; \
   export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install mariadb-server -y

# Copy over startup script
COPY ./startup.sh startup.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Runs mysql server
CMD /app/startup.sh
