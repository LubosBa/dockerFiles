# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download OpenJDK
ADD https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz  .

# Download Logstash.
ADD https://artifacts.elastic.co/downloads/logstash/logstash-7.10.1-linux-x86_64.tar.gz .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/logstash/entrypoint.sh .

# Prepare the container for Logstash.
RUN mkdir -p /opt/java; mkdir -p /opt/logstash; \
    tar -xf openjdk-11+28_linux-x64_bin.tar.gz -C /opt/java --strip-components=1; \
    tar -xf logstash-7.10.1-linux-x86_64.tar.gz -C /opt/logstash --strip-components=1; \
    useradd -u 1001 --shell /bin/bash logstash; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh;

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to elastic user.
USER logstash

# Setups env
ENV JAVA_HOME "/opt/java/"
ENV PATH "${PATH}:${JAVA_HOME}/bin"
ENV LS_SETTINGS_DIR "/config/"

EXPOSE 5044 30123

# Starts ElasticSearch
CMD /opt/entrypoint.sh
