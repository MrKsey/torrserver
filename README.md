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
* 2021-03-30 07:30:17: [YouROK/TorrServer, COMMIT] Merge pull request #42 from PiRomant/patch-1
* 2021-03-29 12:07:11: [YouROK/TorrServer, COMMIT] change def conn limit
* 2021-03-29 12:06:56: [YouROK/TorrServer, COMMIT] remove mutex
* 2021-03-27 05:55:39: [YouROK/TorrServer, COMMIT] subtitles m3u fix for future VLC update
