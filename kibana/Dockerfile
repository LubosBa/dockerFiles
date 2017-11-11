# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /app/

#

# Download Kibana
ADD https://artifacts.elastic.co/downloads/kibana/kibana-5.4.0-linux-x86_64.tar.gz .

# Unpacks Elastic
RUN tar -xf kibana-5.4.0-linux-x86_64.tar.gz && rm kibana-5.4.0-linux-x86_64.tar.gz

# Creates unpriviledged user
RUN useradd -u 1002 --shell /bin/bash kibana

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Sets ownership of folder to our unpriviledged user
RUN chown -R kibana:kibana /app

# Change user to elastic user.
USER kibana


EXPOSE 5601 

# Starts ElasticSearch
CMD /app/kibana-5.4.0-linux-x86_64/bin/kibana serve -c /config/kibana.yml
