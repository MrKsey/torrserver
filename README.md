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
- (optional) put ["ts.ini"](https://raw.githubusercontent.com/MrKsey/torrserver/master/ts.ini) file to "/home/torrserver/db", uncomment the desired options. The "cron_task" parameter (in the cron format) is used to start updates on a schedule. Parameters from "ts.ini" file overwrites the default parameters.
- connect host directory "/home/torrserver/db" to the container directory "/TS/db" and start container:
```
docker run --name torrserver -e TZ=Europe/Moscow -d --restart=always --net=host -v /home/torrserver/db:/TS/db ksey/torrserver
```






























### YouROK/TorrServer last 5 commits:
* 2021-03-12 12:50:58: [YouROK/TorrServer, COMMIT] change load strategy, thx @antibaks
* 2021-03-12 12:49:48: [YouROK/TorrServer, COMMIT] fix for samsung tv
* 2021-03-12 09:09:43: [YouROK/TorrServer, COMMIT] load torrent before send
* 2021-03-12 09:09:18: [YouROK/TorrServer, COMMIT] add load torrent to bt client
