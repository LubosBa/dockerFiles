# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/


# Download metricbeat
ADD https://dl.min.io/server/minio/release/linux-amd64/minio .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/minio/entrypoint.sh .

# Prepare the container for metricbeat.
RUN apt-get update && apt-get install -y xz-utils curl && rm -rf /var/lib/apt/lists/*; \
    mkdir /opt/minio; \
    chmod +x /opt/minio; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]


# Change user to metricbeat user.
USER root

# Execute entrypoint
CMD /opt/entrypoint.sh
