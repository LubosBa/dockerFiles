# Use Debian stable as the base image
FROM debian:stable

# Meta info
LABEL maintainer "lubos@lubos.sk"

# Install required packages
RUN apt-get update && apt-get install -y \
    openssh-server rsync && \
	sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config && \
	useradd -d /data/shelluser -u 2222 -s /bin/bash shelluser && \
	echo "shelluser:strongpassword!" | chpasswd && \
	rm -rf /var/lib/apt/lists/* && \
	mkdir -p /run/sshd
	
COPY entrypoint.sh /

EXPOSE 22

# Setup persistent storage
VOLUME ["/data"]

CMD /entrypoint.sh
