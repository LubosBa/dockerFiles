# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Copy java
ADD https://f.lubos.sk/docker/java.tar.gz .

# Download traccar
ADD https://github.com/tananaev/traccar/releases/download/v4.0/traccar-other-4.0.zip .

# Download entrypoint.sh
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/traccar/entrypoint.sh .

# Prepare the container for traccar.
RUN mkdir -p /opt/java; mkdir -p /opt/traccar; \
    apt-get update && apt-get install -y unzip; \
    rm -rf /var/lib/apt/lists/*; \
    tar -xf java.tar.gz -C /opt/java --strip-components=1; \
    unzip traccar-other-4.0.zip -d /opt/traccar; \
    useradd -u 1001 --shell /bin/bash traccar; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh;

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to traccar user.
USER traccar

# Setups env
ENV JAVA_HOME "/opt/java/"
ENV PATH "${PATH}:${JAVA_HOME}/bin"

# Starts traccar
CMD /opt/entrypoint.sh
