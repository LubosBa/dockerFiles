# Use Debian stable as the base image
FROM alpine:latest

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download Binary
ADD https://dl.vikunja.io/api/0.18.1/vikunja-v0.18.1-linux-amd64-full  .

# Add startup script.
ADD entrypoint.sh .

# Setups the container user + folders
RUN adduser -h /opt/vikunja -s /bin/sh -u 1001 -D vikunja; \
    mkdir -p /opt/vikunja/logs; \
    mkdir -p /opt/vikunja/files; \
    unzip /opt/vikunja-v0.18.1-linux-amd64-full; \
    mv vikunja-v0.18.1-linux-amd64 /opt/vikunja/; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/vikunja/vikunja-v0.18.1-linux-amd64; \
    chmod +x /opt/entrypoint.sh

# Add startup script.
ADD config/config.yml /opt/vikunja/

# Change user to application user..
USER vikunja

EXPOSE 3456

# Setup persistent storage
VOLUME ["/opt/vikunja/files", "/opt/vikunja/logs"]

# Execute entrypoint
CMD /opt/entrypoint.sh