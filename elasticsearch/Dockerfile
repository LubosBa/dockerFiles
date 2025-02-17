# Use Alpine latest as the base image
FROM alpine:latest

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download OpenJDK
ADD https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jre_x64_alpine-linux_hotspot_17.0.4.1_1.tar.gz .

# Download Elastic search
ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.9.0-linux-x86_64.tar.gz .

# Add startup script.
ADD entrypoint.sh .

# Prepare the container for ElasticSearch.
RUN mkdir -p /opt/java; mkdir -p /opt/elasticsearch; \
    tar -xf OpenJDK*.tar.gz -C /opt/java --strip-components=1; \
    tar -xf elasticsearch-*-x86_64.tar.gz -C /opt/elasticsearch --strip-components=1; \
    rm *.tar.gz; \
    adduser -h /opt/ -s /bin/sh -u 1001 -D elastic; \
    apk add bash libc6-compat; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh;

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to elastic user.
USER elastic

# Setups env
ENV ES_JAVA_HOME "/opt/java/"
ENV PATH "${PATH}:${ES_JAVA_HOME}/bin"
ENV ES_PATH_CONF "/config"

# Starts ElasticSearch
CMD /opt/entrypoint.sh
