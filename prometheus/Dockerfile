# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download Prometheus
ADD https://github.com/prometheus/prometheus/releases/download/v2.23.0/prometheus-2.23.0.linux-amd64.tar.gz .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/prometheus/entrypoint.sh .

# Prepare the container for Prometheus.
RUN mkdir -p /opt/prometheus; \
    tar -xf prometheus-2.23.0.linux-amd64.tar.gz -C /opt/prometheus --strip-components=1; \
    useradd -u 1001 --shell /bin/bash prometheus; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to prometheus user.
USER prometheus

# Starts Prometheus
CMD /opt/entrypoint.sh
