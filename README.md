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





























































































































































































* 2021-08-09 05:52:45: [YouROK/TorrServer, COMMIT] cleanup
* 2021-08-09 05:24:21: [YouROK/TorrServer, COMMIT] prefer dn over name with empty title
* 2021-08-09 01:31:10: [YouROK/TorrServer, COMMIT] update logging
* 2021-08-08 23:13:40: [YouROK/TorrServer, COMMIT] add UpnpID
* 2021-08-08 22:40:48: [YouROK/TorrServer, COMMIT] update web
