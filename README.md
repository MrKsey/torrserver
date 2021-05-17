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

















































































































































* 2021-05-08 18:55:40: [YouROK/TorrServer, COMMIT] Merge remote-tracking branch 'origin/master'
* 2021-05-08 18:42:35: [YouROK/TorrServer, COMMIT] add html settings disk cache
* 2021-05-08 18:42:20: [YouROK/TorrServer, COMMIT] add html settings disk cache
* 2021-05-08 18:41:04: [YouROK/TorrServer, COMMIT] refactor and add disk cache
* 2021-05-08 18:39:49: [YouROK/TorrServer, COMMIT] refactor and add disk cache
