# torrserver
### Unofficial Docker Image for TorrServer

This is unofficial dockerized precompiled TorrServer within a debian:stable-slim image.

TorrServer, stream torrent to http

More info:
- https://github.com/YouROK/TorrServer
- https://4pda.ru/forum/index.php?showtopic=889960

### Requirements

* server with docker
* ~128 Mb RAM, ~1 Gb for disk cashe 

### Installing

Create "/home/torrserver/db" directory (for example) on your host, connect host "/home/torrserver/db" directory to the container directory "/TS/db" and start container:
```
docker pull ksey/torrserver
docker run --name torrserver -d --restart=always -v /home/torrserver/db:/TS/db  -p 8090:8090  ksey/torrserver
```
