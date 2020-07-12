# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

#Download node.js
ADD https://nodejs.org/dist/v10.15.1/node-v10.15.1-linux-x64.tar.xz .

# Download ghost
ADD https://github.com/TryGhost/Ghost/releases/download/3.24.0/Ghost-3.24.0.zip .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/ghost/entrypoint.sh .

# Prepare the container for Logstash.
RUN mkdir -p /opt/node; mkdir -p /opt/ghost; \
    apt-get update -y; \
    apt-get install xz-utils -y; \
    apt-get install unzip -y; \
    tar -xf node-v10.15.1-linux-x64.tar.xz -C /opt/node --strip-components=1; \
    unzip Ghost-3.24.0.zip -d /opt/ghost; \
    useradd -d /data/ -u 1001 --shell /bin/bash ghost_user; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh;

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to elastic user.
USER ghost_user

# Setups env

# Starts ElasticSearch
CMD /opt/entrypoint.sh