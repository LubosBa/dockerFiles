# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download Kibana
ADD https://artifacts.elastic.co/downloads/kibana/kibana-6.7.0-linux-x86_64.tar.gz .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/kibana/entrypoint.sh .

# Prepare the container for Kibana.
RUN mkdir -p /opt/kibana; \
    tar -xf kibana-6.7.0-linux-x86_64.tar.gz -C /opt/kibana --strip-components=1; \
    useradd -u 1001 --shell /bin/bash kibana; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to elastic user.
USER kibana

# Load Kibana configuration file.
ENV CONFIG_PATH "/config/kibana.yml"

# Starts Kibana
CMD /opt/entrypoint.sh
