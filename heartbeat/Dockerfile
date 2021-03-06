# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download Elastic search
ADD https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-6.5.1-linux-x86_64.tar.gz .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/heartbeat/entrypoint.sh .

# Prepare the container for ElasticSearch.
RUN mkdir -p /opt/heartbeat; \
    tar -xf heartbeat-6.5.1-linux-x86_64.tar.gz -C /opt/heartbeat --strip-components=1; \
    useradd -u 1001 --shell /bin/bash heartbeat; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh; \
    apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*;


# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to elastic user.
USER heartbeat

# Starts ElasticSearch
CMD /opt/entrypoint.sh
