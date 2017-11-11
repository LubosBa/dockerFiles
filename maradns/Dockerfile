# Uses Debian stable as a base image
FROM debian:stable

# Set workdir
WORKDIR /root/

# Install build esentials
RUN apt-get update && apt-get install build-essential -y

# Downloads MaraDNS source code
ADD http://maradns.samiam.org/download/2.0/2.0.13/maradns-2.0.13.tar.bz2 .

# Unpacks MaraDNS
RUN tar xvf maradns-2.0.13.tar.bz2

# Compiles MaraDNS
RUN cd maradns-2.0.13/ && make

# Create man page folders
RUN mkdir -p /usr/local/share/man/man1 \
mkdir -p /usr/local/share/man/man5 \
mkdir -p /usr/local/share/man/man8

# Installs MaraDNS
RUN cd maradns-2.0.13/ && make install

# Setup persistent storage
VOLUME ["/config", "/zones", "/logs"]

# Open up dns ports
EXPOSE 53/udp 53

# Startup
CMD /config/startup.sh
