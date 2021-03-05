#!/bin/sh

if [ -f "/TS/db/ts.ini" ]; then
    . /TS/db/ts.ini && export $(grep --regexp ^[a-zA-Z] /TS/db/ts.ini | cut -d= -f1)
fi

if [ "$TS_RELEASE" != "latest" ]; then
    export TS_URL=$TS_URL/tags
    export cron_task=""
fi

if $LINUX_UPDATE ; then
    echo " "
    echo "============================================="
    echo "$(date): Start checking for Linux updates ..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update && apt-get upgrade -y && apt-get clean
    echo "Finished checking for Linux updates."
    echo " "
fi

if $TS_UPDATE ; then
    /update_TS.sh
    if [ ! -z "$cron_task" ]; then
        env | grep -v cron_task > /TS/cron_env.sh && chmod a+rx /TS/cron_env.sh
        echo "$cron_task /update_TS.sh >> /var/log/cron.log 2>&1" | crontab -
        cron -f >> /var/log/cron.log 2>&1&
    fi
fi

if [ `ps | grep TorrServer | wc -w` -eq 0 ]; then
    /TS/TorrServer --path=/TS/db/ --port=$TS_PORT&
    sleep 5
    if [ `ps | grep TorrServer | wc -w` -eq 0 ]; then
        echo "Current TorrServer file is corrupted. Trying to restore backup."
        if [ -f "/TS/db/backup/TorrServer" ]; then
            rm -f /TS/TorrServer
            cp -f /TS/db/backup/TorrServer /TS/TorrServer
            chmod a+x /TS/TorrServer
            /TS/TorrServer --path=/TS/db/ --port=$TS_PORT&
            sleep 5
            if [ `ps | grep TorrServer | wc -w` -eq 0 ]; then
                echo "Fatal error!!!"
            else
                echo "Restore backup successful"                
            fi
        else
            echo " "
            echo "Restore backup error! Try the following:"
            echo "1) Download the appropriate file from https://github.com/YouROK/TorrServer/releases manually, unpack and rename it to TorrServer"
            echo "2) Put it to the directory ../db/backup/"
            echo "3) Reboot container"
            echo " "
        fi
    fi
fi

tail -f /dev/null
