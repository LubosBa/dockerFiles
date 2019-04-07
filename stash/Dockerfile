# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download Stash
ADD https://github.com/stashapp/stash/releases/download/v0.0.0-alpha/stash-linux .

# Download FFMPeg
ADD https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/kibana/entrypoint.sh .

# Prepare the container for Kibana.
RUN mkdir -p /opt/stash/.stash; \
    tar -xf ffmpeg-release-amd64-static.tar.xz -C /opt/stash/.stash --strip-components=1; \
    useradd -u 1001 -d /opt/stash --shell /bin/bash stash; \
    mv stash-linux /opt/stash/; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to elastic user.
USER stash

# Starts Kibana
CMD /opt/entrypoint.sh
