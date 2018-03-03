# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Workdir
WORKDIR /opt/

ADD http://tux.rainside.sk/apache/guacamole/0.9.14/source/guacamole-server-0.9.14.tar.gz .

RUN tar -xf guacamole-server-0.9.14.tar.gz  -C /opt/; \
    apt-get update && \
    apt-get install -y build-essential pkg-config automake libcairo2-dev \
    libjpeg62-turbo-dev libpng-dev libossp-uuid-dev \
    libavutil-dev libswscale-dev 	libfreerdp-dev libpango1.0-dev libssh2-1-dev \
    libtelnet-dev libvncserver-dev 	libpulse-dev 	libssl-dev libvorbis-dev \
    libwebp-dev libavcodec-dev; \
    rm -rf /var/lib/apt/lists/*; \
    /opt/guacamole-server-0.9.14/configure --prefix=/opt/env && make && make install; \
    useradd -u 1001 --shell /bin/bash guacad

USER guacad

CMD /opt/env/sbin/guacd -b 0.0.0.0 -l 4823
