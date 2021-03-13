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
























* 2021-03-12 07:29:14: [YouROK/TorrServer, COMMIT] add remove views all
* 2021-03-12 07:29:03: [YouROK/TorrServer, COMMIT] add remove views
* 2021-03-12 07:13:09: [YouROK/TorrServer, COMMIT] update web
* 2021-03-11 17:41:05: [YouROK/TorrServer, COMMIT] fix add subs to m3u
* 2021-03-11 17:19:08: [YouROK/TorrServer, COMMIT] add subs to m3u
