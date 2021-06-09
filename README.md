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









































# #
### YouROK/TorrServer last 5 commits:
* 2021-06-08 16:38:49: [YouROK/TorrServer, COMMIT] MatriX.98
* 2021-06-08 16:38:26: [YouROK/TorrServer, COMMIT] add docker compile
* 2021-06-08 16:37:53: [YouROK/TorrServer, COMMIT] update web
* 2021-06-08 08:16:29: [YouROK/TorrServer, COMMIT] Merge pull request #67 from tsynik/i18n-update
* 2021-06-07 16:03:36: [YouROK/TorrServer, COMMIT] translate donate snackbar and torrent states
