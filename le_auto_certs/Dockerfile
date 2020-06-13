# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /certs/

# Download OpenJDK
ADD https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz  /opt/

# Prepare the container.
RUN apt update && apt upgrade -y; \
    apt install openssl curl python-pip certbot nano python3-certbot-dns-cloudflare -y; \
    tar -xf openjdk-11+28_linux-x64_bin.tar.gz -C /opt/java --strip-components=1; \
    rm /opt/openjdk-11+28_linux-x64_bin.tar.gz; \
    mkdir /certs/;

# Add startup script.
ADD https://raw.githubusercontent.com/LubosBa/dockerFiles/master/le_auto_certs/entrypoint.sh .

# Setup persistent storage
VOLUME [ "/certs" ]


# Setups env
ENV JAVA_HOME "/opt/java/"
ENV PATH "${PATH}:${JAVA_HOME}/bin"

# Start the container
CMD /opt/entrypoint.sh