# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download OpenJDK
ADD https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz  .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/le_auto_certs/entrypoint.sh .

# Prepare the container.
RUN apt update && apt upgrade -y; \
    apt install openssl curl certbot nano python3-certbot-dns-cloudflare -y; \
    mkdir -p /opt/java; \
    tar -xf openjdk-11+28_linux-x64_bin.tar.gz -C /opt/java --strip-components=1; \
    rm openjdk-11+28_linux-x64_bin.tar.gz; \
    chmod +x /opt/entrypoint.sh

# Setup persistent storage
VOLUME [ "/certs" ]


# Setups env
ENV JAVA_HOME "/opt/java/"
ENV PATH "${PATH}:${JAVA_HOME}/bin"

# Start the container
ENTRYPOINT [ "/opt/entrypoint.sh" ]