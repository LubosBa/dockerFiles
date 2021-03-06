# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download OpenJDK
ADD https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz  .

# Download Elastic search
ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.1-linux-x86_64.tar.gz .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/elasticsearch/entrypoint.sh .

# Prepare the container for ElasticSearch.
RUN mkdir -p /opt/java; mkdir -p /opt/elasticsearch; \
    tar -xf openjdk-11+28_linux-x64_bin.tar.gz -C /opt/java --strip-components=1; \
    tar -xf elasticsearch-7.10.1-linux-x86_64.tar.gz -C /opt/elasticsearch --strip-components=1; \
    useradd -u 1001 --shell /bin/bash elastic; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh;

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to elastic user.
USER elastic

# Setups env
ENV JAVA_HOME "/opt/java/"
ENV PATH "${PATH}:${JAVA_HOME}/bin"
ENV ES_PATH_CONF "/config"

# Starts ElasticSearch
CMD /opt/entrypoint.sh
