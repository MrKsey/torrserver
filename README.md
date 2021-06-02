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

- сreate "/home/torrserver/db" directory (for example) on your host
- (optional) put ["ts.ini"](https://raw.githubusercontent.com/MrKsey/torrserver/master/ts.ini) file to "/home/torrserver/db", uncomment the desired options. The "cron_task" parameter (in the cron format) is used to start updates on a schedule. Parameters from "ts.ini" file overwrites the default parameters.
- connect host directory "/home/torrserver/db" to the container directory "/TS/db" and start container:
```
docker run --name torrserver -e TZ=Europe/Moscow -d --restart=always --net=host -v /torrserver/db:/TS/db ksey/torrserver
```



### YouROK/TorrServer last 5 commits:
* 2021-06-01 12:59:14: [YouROK/TorrServer, COMMIT] release pieces on torrent drop
* 2021-06-01 11:52:27: [YouROK/TorrServer, COMMIT] MatriX.96
* 2021-06-01 09:23:59: [YouROK/TorrServer, COMMIT] Update README.md
* 2021-06-01 09:11:58: [YouROK/TorrServer, COMMIT] update web
* 2021-06-01 09:11:47: [YouROK/TorrServer, COMMIT] set disk cache as mem cache
