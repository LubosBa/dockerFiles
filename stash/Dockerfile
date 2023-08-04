# Use Debian stable as the base image
FROM alpine:latest

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download Stash
ADD https://github.com/stashapp/stash/releases/download/v0.12.0/stash-linux  .


# Add startup script.
ADD entrypoint.sh .

# Copy main configuration
ADD config/config.yml .

# Prepare the container for Kibana.
#RUN mkdir -p /opt/stash/.stash; \
#    apt-get update && apt-get install -y xz-utils curl && rm -rf /var/lib/apt/lists/*; \
#    tar -xf ffmpeg-release-amd64-static.tar.xz -C /opt/stash/.stash --strip-components=1; \
#    useradd -u 1001 -d /opt/stash --shell /bin/bash stash; \
#    mv stash-linux /opt/stash/; \
#    chown -R 1001:1001 /opt/*; \
#    chmod +x /opt/stash/stash-linux; \
#    chmod +x /opt/entrypoint.sh

RUN apk --no-cache add ca-certificates python3 py3-requests py3-requests-toolbelt py3-lxml py3-pip ffmpeg vips-tools && pip install --no-cache-dir mechanicalsoup cloudscraper; \
    adduser -h /opt/stash -s /bin/sh -u 1001 -D stash; \
    mkdir -p /opt/stash; \
    mv stash-linux /opt/stash/; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/stash/stash-linux; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

EXPOSE 9999

# Change user to elastic user.
USER stash

# Execute entrypoint
CMD /opt/entrypoint.sh
