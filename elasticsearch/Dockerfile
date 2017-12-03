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
ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.0.0.tar.gz .

# Unpacks Elastic
RUN tar -xf elasticsearch-6.0.0.tar.gz && rm elasticsearch-6.0.0.tar.gz

# Creates unpriviledged user
RUN useradd -u 1000 --shell /bin/bash elastic

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Sets ownership of folder to our unpriviledged user
RUN chown -R elastic:elastic /app

# Change user to elastic user.
USER elastic

# Setups env
ENV JAVA_HOME "/app/java/"
ENV PATH "${PATH}:${JAVA_HOME}/bin"
ENV ES_PATH_CONF "/config"

# Starts ElasticSearch
CMD /app/elasticsearch-6.0.0/bin/elasticsearch
