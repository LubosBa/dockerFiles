# Use Alpine latest as the base image
FROM alpine:latest

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/


# Download FileBeat
ADD https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.9.0-linux-x86_64.tar.gz .

# Add startup script.
ADD entrypoint.sh .

# Prepare the container for FileBeat.
RUN mkdir /opt/filebeat; \
    tar -xf filebeat-*.tar.gz -C /opt/filebeat --strip-components=1; \
    adduser -h /opt/ -s /bin/sh -u 1001 -D beats; \
    apk add bash libc6-compat; \
    chown -R 1001:1001 /opt/*; \
    rm *.tar.gz; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config", "/app_logs"]


# Change user to FileBeat user.
USER beats

# Execute entrypoint
CMD /opt/entrypoint.sh
