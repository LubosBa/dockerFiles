# Use Alpine latest as the base image
FROM alpine:latest

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download application
ADD https://dl.min.io/server/minio/release/linux-amd64/minio .

# Add startup script.
ADD entrypoint.sh .

# Prepare the container for application.
RUN apk --no-cache add curl openssl; \
    adduser -h /opt/ -s /bin/sh -u 1001 -D minio; \
    mkdir /data; \
    chown -R 1001:1001 /opt/* /data; \
    chmod +x /opt/minio; \
    chmod +x /opt/entrypoint.sh

# Expose application ports
EXPOSE 9000

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]


# Change user to application user.
USER minio

# Execute entrypoint
CMD /opt/entrypoint.sh
