# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download OpenJDK
ADD https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz  .

# Download ZooKeeper
ADD https://archive.apache.org/dist/zookeeper/zookeeper-3.5.7/apache-zookeeper-3.5.7-bin.tar.gz .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/zookeeper/entrypoint.sh .

# Prepare the container for Kibana.
RUN apt-get update && apt-get install -y xz-utils curl && rm -rf /var/lib/apt/lists/*; \
    tar -xf openjdk-11+28_linux-x64_bin.tar.gz; \
    tar -xf apache-zookeeper-3.5.7-bin.tar.gz; \
    useradd -u 1001 -d /opt/ --shell /bin/bash zookeeper; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Stash config
ENV ZOO_LOG_DIR "/logs"
ENV JAVA_HOME "/opt/jdk-11"
ENV PATH "${PATH}:${JAVA_HOME}/bin"


EXPOSE 2181

# Change user to elastic user.
USER zookeeper

# Execute entrypoint
CMD /opt/entrypoint.sh
