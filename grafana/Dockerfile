# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download Prometheus
ADD https://dl.grafana.com/oss/release/grafana-7.2.1.linux-amd64.tar.gz .

# Add startup script.
COPY entrypoint.sh .

# Prepare the container for Prometheus.
RUN mkdir -p /opt/grafana; \
    apt-get update -y; \
    apt-get install unzip curl -y; \
    tar -xf grafana-7.2.1.linux-amd64.tar.gz -C /opt/grafana --strip-components=1; \
    useradd -u 1001 --shell /bin/bash grafana; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to prometheus user.
USER grafana

# Starts Prometheus
CMD /opt/entrypoint.sh
