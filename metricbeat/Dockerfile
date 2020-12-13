# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/


# Download metricbeat
ADD https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.10.1-linux-x86_64.tar.gz .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/metricbeat/entrypoint.sh .

# Prepare the container for metricbeat.
RUN apt-get update && apt-get install -y xz-utils curl && rm -rf /var/lib/apt/lists/*; \
    mkdir /opt/metricbeat; \
    tar -xf metricbeat-7.10.1-linux-x86_64.tar.gz -C /opt/filebeat --strip-components=1; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]


# Change user to metricbeat user.
USER root

# Execute entrypoint
CMD /opt/entrypoint.sh
