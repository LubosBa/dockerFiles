# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /app/

# Copy java
COPY java8.tar.gz ./java8.tar.gz

# Unpacks java
RUN tar xf java8.tar.gz && mv jre1.8.0_131 java

# Download Elastic search
ADD https://artifacts.elastic.co/downloads/logstash/logstash-6.0.0.tar.gz .

# Unpacks Elastic
RUN tar -xf logstash-6.0.0.tar.gz && rm logstash-6.0.0.tar.gz

# Creates unpriviledged user
RUN useradd -u 1001 --shell /bin/bash logstash

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Sets ownership of folder to our unpriviledged user
RUN chown -R logstash:logstash /app

# Change user to elastic user.
USER logstash

# Setups env
ENV JAVA_HOME "/app/java/"
ENV PATH "${PATH}:${JAVA_HOME}/bin"

EXPOSE 5044

# Starts ElasticSearch
CMD /app/logstash-6.0.0/bin/logstash --path.settings /config/
