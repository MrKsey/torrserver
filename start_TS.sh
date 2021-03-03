#!/bin/sh

if [ -f /TS/db/ts.ini ]; then
    set -a
    source /TS/db/ts.ini
    set +a
fi

if [ "$TS_RELEASE" != "latest" ]; then
    export TS_URL=$TS_URL/tags
    export cron_task=""
fi

if $LINUX_UPDATE ; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update && apt-get upgrade -y
fi

if $TS_UPDATE ; then
    /update_TS.sh
    if [ ! -z "$cron_task" ]; then
        echo "$cron_task /update_TS.sh" | crontab -
    else
        crontab -r
    fi
fi

if [ `ps | grep TorrServer | wc -w` -eq 0 ]; then
    /TS/TorrServer --path=/TS/db/ --port=$TS_PORT&
fi

tail -f /dev/null
