# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download etcd
ADD https://github.com/etcd-io/etcd/releases/download/v3.4.14/etcd-v3.4.14-linux-amd64.tar.gz  .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/etcd/entrypoint.sh .

# Prepare the container for etcd.
RUN apt-get update && apt-get install -y xz-utils curl && rm -rf /var/lib/apt/lists/*; \
    mkdir -p /opt/etcd;  \
    tar -xf etcd-v3.4.14-linux-amd64.tar.gz -C /opt/etcd --strip-components=1; \
    useradd -u 1001 --shell /bin/bash etcd; \
    chown -R 1001:1001 /opt/*; \
    chmod +x /opt/entrypoint.sh;

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user to etcd user.
USER etcd

# Start the container
ENTRYPOINT [ "/opt/entrypoint.sh" ]