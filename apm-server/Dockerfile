# Use Alpine latest as the base image
FROM alpine:latest

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download Elastic search
ADD https://artifacts.elastic.co/downloads/apm-server/apm-server-8.9.0-linux-x86_64.tar.gz .
# Add startup script.
ADD entrypoint.sh .

# Prepare the container for ElasticSearch.
RUN mkdir -p /opt/apm-server; \
    tar -xf apm-server-*-x86_64.tar.gz -C /opt/apm-server --strip-components=1; \
    rm *.tar.gz; \
    adduser -h /opt/ -s /bin/sh -u 1001 -D apm; \
    apk add bash libc6-compat; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh;

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to elastic user.
USER apm

# Starts ElasticSearch
CMD /opt/entrypoint.sh
