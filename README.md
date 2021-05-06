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
* 2021-04-29 08:35:40: [YouROK/TorrServer, COMMIT] fix log rewrite
* 2021-04-28 13:48:02: [YouROK/TorrServer, COMMIT] MatriX.92.1
* 2021-04-28 13:29:54: [YouROK/TorrServer, COMMIT] revert clean cache
* 2021-04-28 13:28:59: [YouROK/TorrServer, COMMIT] change compile prior
* 2021-04-28 13:26:37: [YouROK/TorrServer, COMMIT] Merge pull request #47 from qarkai/issue-45
