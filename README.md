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
























































































* 2021-04-14 13:58:21: [YouROK/TorrServer, COMMIT] change no auth status
* 2021-04-14 11:35:07: [YouROK/TorrServer, COMMIT] MatriX.89
* 2021-04-14 11:28:58: [YouROK/TorrServer, COMMIT] MatriX.88.2
* 2021-04-14 11:25:35: [YouROK/TorrServer, COMMIT] fix m3u auth
* 2021-04-13 08:01:34: [YouROK/TorrServer, COMMIT] MatriX.88.1
