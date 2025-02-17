# Use Alpine latest as the base image
FROM alpine:latest

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download Kibana
ADD https://artifacts.elastic.co/downloads/kibana/kibana-8.9.0-linux-x86_64.tar.gz .

# Add startup script.
ADD entrypoint.sh .

# Prepare the container for Kibana.
RUN mkdir -p /opt/kibana; \
    tar -xf kibana-*.tar.gz -C /opt/kibana --strip-components=1; \
    adduser -h /opt/ -s /bin/sh -u 1001 -D kibana; \
    rm *.tar.gz; \
    chown -R 1001:1001 /opt/*; \
    apk add bash libgcc libc6-compat libstdc++ gcompat; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to elastic user.
USER kibana

# Load Kibana configuration file.
ENV KBN_PATH_CONF "/config"

# Starts Kibana
CMD /opt/entrypoint.sh
