# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download Stash
ADD https://github.com/stashapp/stash/releases/download/v0.4.0/stash-linux  .

# Download FFMPeg
ADD https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz .

# Add startup script.
ADD https://github.com/LubosBa/dockerFiles/raw/d461c5a4ed3039a9a4532aeca027cdfaebf8752c/stash/entrypoint.sh .

# Prepare the container for Kibana.
RUN mkdir -p /opt/stash/.stash; \
    apt-get update && apt-get install -y xz-utils curl && rm -rf /var/lib/apt/lists/*; \
    tar -xf ffmpeg-release-amd64-static.tar.xz -C /opt/stash/.stash --strip-components=1; \
    useradd -u 1001 -d /opt/stash --shell /bin/bash stash; \
    mv stash-linux /opt/stash/; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/stash/stash-linux; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Stash config
ENV STASH_STASH "/data/collection/"
ENV STASH_GENERATED "/data/generated/"
ENV STASH_METADATA "/data/metadata/"
ENV STASH_CACHE "/data/cache/"

EXPOSE 9999

# Change user to elastic user.
USER stash

# Execute entrypoint
CMD /opt/entrypoint.sh
