# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download OpenJDK
ADD https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz  .

# Download Kafka
ADD https://downloads.apache.org/kafka/2.6.0/kafka_2.13-2.6.0.tgz .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/kafka/entrypoint.sh .

# Prepare the container for Kibana.
RUN apt-get update && apt-get install -y xz-utils curl && rm -rf /var/lib/apt/lists/*; \
    tar -xf openjdk-11+28_linux-x64_bin.tar.gz; \
    tar -xf kafka_2.13-2.6.0.tgz; \
    useradd -u 1001 -d /opt/ --shell /bin/bash kafka; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Stash config
ENV LOG_DIR "/logs"
ENV KAFKA_LOG4J_OPTS "-Dlog4j.configuration=file:/config/log4j.properties"
ENV KAFKA_HEAP_OPTS "-Xms2G -Xmx2G"
ENV JAVA_HOME "/opt/jdk-11"
ENV PATH "${PATH}:${JAVA_HOME}/bin"


EXPOSE 9092 9091 9093

# Change user to kafka user.
USER kafka

# Execute entrypoint
CMD /opt/entrypoint.sh
