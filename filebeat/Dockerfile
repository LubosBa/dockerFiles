# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/


# Download FileBeat
ADD https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.1-linux-x86_64.tar.gz .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/filebeat/entrypoint.sh .

# Prepare the container for FileBeat.
RUN apt-get update && apt-get install -y xz-utils curl && rm -rf /var/lib/apt/lists/*; \
    mkdir /opt/filebeat; \
    tar -xf filebeat-7.6.1-linux-x86_64.tar.gz -C /opt/filebeat --strip-components=1; \
    useradd -u 1001 -d /opt/ --shell /bin/bash filebeat; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]


# Change user to FileBeat user.
USER filebeat

# Execute entrypoint
CMD /opt/entrypoint.sh
