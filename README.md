# torrserver
### Unofficial Docker Image for TorrServer

This is unofficial dockerized precompiled TorrServer within a debian:stable-slim image.

"TorrServer, stream torrent to http"

![TorrServer](https://raw.githubusercontent.com/MrKsey/torrserver/master/ts.jpg)

More info:
- https://github.com/YouROK/TorrServer
- https://4pda.ru/forum/index.php?showtopic=889960

### Requirements

* server with docker
* ~256 Mb RAM, ~512 Mb disk space 

### Installing

- сreate "/torrserver/db" directory (for example) on your host
- (optional) put ["ts.ini"](https://raw.githubusercontent.com/MrKsey/torrserver/master/ts.ini) file to "/torrserver/db", uncomment the desired options. The "cron_task" parameter (in the cron format) is used to start updates on a schedule. Parameters from "ts.ini" file overwrites the default parameters.
- connect host directory "/torrserver/db" to the container directory "/TS/db" and start container:
```
docker run --name torrserver -e TZ=Europe/Moscow -d --restart=always --net=host -v /torrserver/db:/TS/db ksey/torrserver
```









* 2021-09-11 20:08:51: [YouROK/TorrServer, COMMIT] return NoSuchObject in case no meta
* 2021-09-11 19:50:56: [YouROK/TorrServer, COMMIT] gofmt -l -w .
* 2021-09-11 19:48:07: [YouROK/TorrServer, COMMIT] rework torrents meta response
* 2021-09-11 17:32:29: [YouROK/TorrServer, COMMIT] remove local build
* 2021-09-11 17:31:44: [YouROK/TorrServer, COMMIT] fix build
