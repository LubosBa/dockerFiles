# dockerFiles backup repository

This repository acts as a backup of all my Docker images I have ever created.
Since I don't want to store actual images, I only store Dockerfiles so I can
freely rebuild images in case of emergency.

### Available images
* [ElasticSearch](#ElasticSearch)
* [PHP-FPM](#php-fpm)
* [Kibana](#kibana)
* [Logstash](#logstash)
* [MaraDNS](#maradns)
* [MariaDB](#mariadb)
* [nginx](#nginx)
* [sshd](#sshd)
* [torrent(rTorrent + ruTorrent)](#torrent)
* [znc](#znc)

## Image usage and dependencies

### ElasticSearch
This Dockerfile will build ElasticSearch 5.4 image for you, it doesn't set any
default configuration file for ElasticSearch itself, therefore one must be
provided in `/config` mointpoint. Same applies to JVM and log4j configuration
which are loaded from the same directory.

Data are stored in `/data` mountpoint while logs are stored in `/logs`.

**Dependency:** `java8.tar.gz` file present in build dir.

Example CLI usage:
```
docker run -d --name "esd1" --hostname "esd1" \
--volume=/configs:/config \
--volume=/logs:/logs \
--volume=/data:/data \
elastic-lubos:stable
```

### PHP-FPM
This Dockerfile will build portable PHP-FPM based on
[Dotdeb](https://www.dotdeb.org/) repositories image for you. It doesn't ship
any default configuration for PHP, therefore one must be provided in `/config`
mountpoint. PHP process runs under UID and GID **9999**

Data are stored in `/www` mountpoint while logs are stored in `/logs`.

Example CLI usage:
```
docker run -d --name "phps1" --hostname "phps1" \
--volume=/config:/config \
--volume=/logs:/logs \
--volume=/www:/www \
fpm-lubos:stable
```

### Kibana
This Dockerfile will build Kibana 5.4 image for you, it doesn't set any default
configuration file for Kibana itself, therefore one must be provided in
`/config` mountpoint. Kibana runs under UID and GID **1002**

Data are stored in `/data` mountpoint while logs are stored in `/logs`.

Example CLI usage:
```
docker run -d -p 100.100.100.100:5601:5601 \
--volume=/config:/config \
--volume=/logs:/logs \
--volume=/data:/data \
kibana-lubos:stable
```

### Logstash
This Dockerfile will build Logstash 5.4 image for you, it doesn't set any
default configuration file for Logstash itself, therefore one must be provided
in `/config` mountpoint. Logstash runs under UID and GID **1001**.

Data are stored in `/data` mountpoint while logs are stored in `/logs`.

**Dependency:** `java8.tar.gz` file present in build dir.

Example CLI usage:
```
docker run -d \
--volume=/config:/config \
--volume=/logs:/logs \
--volume=/data:/data \
logstash-lubos:stable
```

### MaraDNS
This Dockerfile will build MaraDNS image for you, it doesn't set any default
configuration file for MaraDNS itself, therefore one must be provided in `/config`
 mountpoint.

Data are stored in `/zones` mountpoint while logs are stored in `/logs`. Startup
 script `startup.sh` must be present in `/config` mountpoint as this image
 doesn't shit any startup script itself. The image also exposes both ports
 53/tcp and 53/udp.

Example CLI usage:
```
docker run -d -p 100.100.100.100:53 -p 100.100.100.100:53/udp \
--name "dns1" --hostname "dns1.m8.sk" \
--volume=/data/containers/conf/dns1.m8.sk:/config \
--volume=/data/containers/logs/dns1.m8.sk:/logs \
--volume=/data/containers/data/dns1.m8.sk:/zones \
maradns-lubos:stable
```

### MariaDB
This Dockerfile will build MariaDB image for you from official MariaDB Debian
repositories. It doesn't set any default configuration file for MariaDB itself,
therefore one must be provided in `/config` mountpoint. In case that the DB
hasn't been initialized yet, the `startup.sh` will setup the DB for you with
default username **admin** and default password **admin12340!**

Data are stored in `/data` mountpoint while logs are stored in `/logs`.

Example CLI usage:
```
docker run -d \
--volume=/config:/config \
--volume=/data:/data \
--volume=/logs:/logs \
--name=sqls1 \
mariadb-lubos:stable
```

### nginx
This Dockerfile will build portable nginx based on
[Dotdeb](https://www.dotdeb.org/) repositories image for you. It doesn't ship
any default configuration for PHP, therefore one must be provided in `/config`
mountpoint.

Data are stored in `/www` mountpoint while logs are stored in `/logs`.

Example CLI usage:
```
docker run -d -p 100.100.100.100:80:80 -p  100.100.100.100:443:443 \
--name "webs1" --hostname "webs1" \
--volume=/config:/config \
--volume=/logs:/logs \
--volume=/www:/www \
nginx-lubos:latest
```


### sshd
This Dockerfile will build portable sshd container. No configuration is required
 as the default one is used. User **shelluser** will be automatically created
 with UID:GID **2222** and passowrd **strongpassword!**. User data are stored in
`/data` mountpoint therefore usage of this image is recommended when you want
to grant access to your server to 3rd party for storage purpuses.

Example CLI usage:
```
docker run -d -p 100.100.100.100:2222:22  \
--volume=/data/containers/data/sshd1.m8.sk:/data \
sshd:latest
```
### torrent
This Dockerfile will build portable seedbox within Docker container. It includes
nginx, PHP-FPM, rtorrent + rutorrent. Torrent data are stored in `/torrent`
mountpoint while logs are stored in `/logs` mountpoint.

Example CLI usage:
```
docker run -d -p 100.100.100.100:49164:49164  \
--volume=/torrent:/torrent \
--volume=/logs:/logs \
rtorrent:stable
```

### znc
This Dockerfile will build portable ZNC image for you. It generates ZNC
configuration for you, if it already doesn't exist. Otherwise it just startups
ZNC.

Data, configuration and logs are stored in following mountpoints
`/data`, `/config`, `/logs`. ZNC is run under **znc** user so make sure that
your `/config` folder has sticky bit set so znc user can write config into the
folder. Port 25000 can be exposed for web based ZNC interface.

Example CLI usage, first run:
```
docker run -it --name="zncs1" --hostname="zncs1" \
--volume=/config:/config \
--volume=/data:/data \
--volume=/logs:/logs \
-p 25000:25000 znc:latest
```
Second run:
```
docker start zncs1
```
