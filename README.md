# torrserver
### Unofficial Docker Image for TorrServer

This is unofficial dockerized precompiled TorrServer within a debian:stable-slim image.

"TorrServer, stream torrent to http"

More info:
- https://github.com/YouROK/TorrServer
- https://4pda.ru/forum/index.php?showtopic=889960

### Requirements

* server with docker
* ~128 Mb RAM, ~1 Gb for disk cashe 

### Installing

- сreate "/home/torrserver/db" directory (for example) on your host
- connect host directory "/home/torrserver/db" to the container directory "/TS/db" and start container:
```
docker run --name torrserver -d --restart=always -v /home/torrserver/db:/TS/db  -p 8090:8090  ksey/torrserver
```


* 2021-02-28 18:40:35: [YouROK/TorrServer, COMMIT] MatriX.81
* 2021-02-25 11:05:51: [YouROK/TorrServer, COMMIT] update web
* 2021-02-25 11:05:14: [YouROK/TorrServer, COMMIT] add viewed
* 2021-02-24 19:35:17: [YouROK/TorrServer, COMMIT] update web
* 2021-02-24 19:33:49: [YouROK/TorrServer, COMMIT] chage playlist to link
