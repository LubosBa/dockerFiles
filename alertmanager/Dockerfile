# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download Alertmanager
ADD https://github.com/prometheus/alertmanager/releases/download/v0.21.0/alertmanager-0.21.0.linux-amd64.tar.gz .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/alertmanager/entrypoint.sh .

# Prepare the container for Alertmanager.
RUN mkdir -p /opt/alertmanager; \
    tar -xf alertmanager-0.21.0.linux-amd64.tar.gz -C /opt/alertmanager --strip-components=1; \
    useradd -u 1001 --shell /bin/bash alertmanager; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to alertmanager user.
USER alertmanager

# Starts alertmanager
CMD /opt/entrypoint.sh
