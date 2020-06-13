# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /certs/

# Download OpenJDK
ADD https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz  .

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/le_auto_certs/entrypoint.sh .

# Prepare the container.
RUN apt update && apt upgrade -y; \
    apt install openssl curl certbot nano python3-certbot-dns-cloudflare -y; \
    tar -xf openjdk-11+28_linux-x64_bin.tar.gz -C /certs/java --strip-components=1; \
    rm openjdk-11+28_linux-x64_bin.tar.gz; \
    mkdir /certs/; \
    chmod +x /certs/entrypoint.sh

# Setup persistent storage
VOLUME [ "/certs" ]


# Setups env
ENV JAVA_HOME "/certs/java/"
ENV PATH "${PATH}:${JAVA_HOME}/bin"

# Start the container
ENTRYPOINT [ "/certs/entrypoint.sh" ]