# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

# Download tomcat
ADD http://tux.rainside.sk/apache/tomcat/tomcat-8/v8.5.28/bin/apache-tomcat-8.5.28.tar.gz .

# Copy java
COPY java8.tar.gz ./java8.tar.gz

# Add startup script.
COPY entrypoint.sh ./entrypoint.sh

# Create base directories.
RUN mkdir /opt/java; mkdir /opt/tomcat; \
    tar -xf java8.tar.gz -C /opt/java --strip-components=1; \
    tar -xf apache-tomcat-8.5.28.tar.gz -C /opt/tomcat --strip-components=1; \
    useradd -u 1001 --shell /bin/bash tomcat; \
    chown -R 1001:1001 /opt; \
    mkdir /tomcat; mkdir /tomcat/bin; mkdir /tomcat/temp; mkdir /tomcat/work; \
    chown -R 1001:1001 /tomcat/*

# Setup persistent storage
VOLUME ["/tomcat/logs", "/tomcat/webapps", "/tomcat/conf", "/tomcat/lib"]

USER tomcat

# Setups env
ENV JAVA_HOME "/opt/java/"
ENV PATH "${PATH}:${JAVA_HOME}/bin"
ENV CATALINA_BASE "/tomcat"
ENV GUACAMOLE_HOME "/tomcat/conf/"

CMD /opt/entrypoint.sh
