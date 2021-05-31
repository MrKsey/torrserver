#!/bin/sh

if [ -e /TS/db/ts.ini ]; then
    . /TS/db/ts.ini && export $(grep --regexp ^[a-zA-Z] /TS/db/ts.ini | cut -d= -f1)
fi

if [ -e /TS/cron.env ]; then
    rm -f /TS/cron.env
fi

if $LINUX_UPDATE ; then
    echo " "
    echo "============================================="
    echo "$(date): Start checking for Linux updates ..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update && apt-get upgrade -y && apt-get clean
    echo "Finished checking for Linux updates."
    echo "============================================="
    echo " "
fi

/TS/TorrServer --path=/TS/db/ --port=$TS_PORT $TS_OPTIONS &
sleep 5
if [ `ps | grep TorrServer | wc -w` -eq 0 ]; then
    echo "Current TorrServer file is corrupted or invalid options. Trying to recover."
    /TS/TorrServer --path=/TS/db/ --port=$TS_PORT&
    if [ `ps | grep TorrServer | wc -w` -eq 0 ]; then
        if [ -e /TS/db/backup/TorrServer ]; then
            rm -f /TS/TorrServer
            cp -f /TS/db/backup/TorrServer /TS/TorrServer
            chmod a+x /TS/TorrServer
            /TS/TorrServer --path=/TS/db/ --port=$TS_PORT&
            sleep 5
            if [ `ps | grep TorrServer | wc -w` -eq 0 ]; then
                echo "Fatal error!!!"
            else
                echo "Started from backup without options"                
            fi
        else
            echo " "
            echo "Restore backup error! Try the following:"
            echo "1) Download the appropriate file from https://github.com/YouROK/TorrServer/releases manually, unpack and rename it to TorrServer"
            echo "2) Put it to the directory ../db/backup/"
            echo "3) Reboot container"
            echo " "
        fi
    else
        echo "Started without options."
        export TS_OPTIONS=""
    fi
fi

if [ "$TS_RELEASE" != "latest" ]; then
    export TS_URL=$TS_URL/tags
fi

env | grep -v cron_task > /TS/cron.env && chmod a+r /TS/cron.env

if $TS_UPDATE ; then
    . /update_TS.sh
fi

if [ ! -z "$cron_task" ]; then
    echo "$cron_task /update_TS.sh >> /var/log/cron.log 2>&1" | crontab -
    cron -f >> /var/log/cron.log 2>&1&
fi

tail -f /dev/null
