# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /root/

# Downloads znc source
COPY znc-1.6.5.tar.gz .

# Unpack tar ball
RUN tar -xf znc-1.6.5.tar.gz && rm znc-1.6.5.tar.gz

# Install dev packages and setup user
RUN useradd -d /config -s /usr/bin/bash znc; \
apt-get update && apt-get install -y \
	build-essential \
	libssl-dev \
	libperl-dev \
	pkg-config \
	libicu-dev \
	zlib1g-dev \
&& rm -rf /var/lib/apt/lists/*

# Compile znc
RUN mkdir -p /opt/znc && ./znc-1.6.5/configure --prefix=/opt/znc && \
    make && make install

# Expose ports
EXPOSE 25000

# Setup persistent storage
VOLUME ["/logs", "/data", "/config"]

# Change user
USER znc

# Entry point of ZNC
CMD /config/entrypoint.sh
