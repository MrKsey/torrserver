#!/bin/sh

# Configuration file ts.ini source. Do not change!
export INI_URL="https://raw.githubusercontent.com/MrKsey/torrserver/main/ts.ini"
if [ ! -e /TS/db/ts.ini ]; then
    wget -q --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:77.0) Gecko/20100101 Firefox/77.0" --content-disposition "$INI_URL" -O /TS/db/ts.ini
    if [ -e /TS/db/ts.ini ]; then
        echo " "
        echo "============================================="
        echo "$(date): File /TS/db/ts.ini downloaded from the github."
        echo "============================================="
        echo " "
    fi
fi

if [ -e /TS/db/ts.ini ]; then
    chmod a+r /TS/db/ts.ini
    sed -i -e "s/\r//g" /TS/db/ts.ini
    . /TS/db/ts.ini && export $(grep --regexp ^[a-zA-Z] /TS/db/ts.ini | cut -d= -f1)
    echo "============================================="
    echo "$(date): Configuration settings from ts.ini file:"
    echo " "
    echo "$(cat /TS/db/ts.ini | grep --regexp ^[a-zA-Z])"
    echo " "
    echo "============================================="
    echo " "
fi

# File accs.db source. Do not change!
export ACCS_URL="https://raw.githubusercontent.com/MrKsey/torrserver/main/accs.db"
if [ ! -e /TS/db/accs.db ]; then
    wget -q --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:77.0) Gecko/20100101 Firefox/77.0" --content-disposition "$ACCS_URL" -O /TS/db/accs.db
    if [ -e /TS/db/accs.db ]; then
        echo " "
        echo "============================================="
        echo "$(date): File /TS/db/accs.db downloaded from the github."
        echo "============================================="
        echo " "
    fi
fi

# Cleanup env settings
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

echo " "
echo "============================================="
echo "$(date): Starting TorrServer ..."
echo " "
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

env | grep -v cron_task | awk 'NF {sub("=","=\"",$0); print ""$0"\""}' > /TS/cron.env && chmod a+r /TS/cron.env

if $TS_UPDATE ; then
    . /update_TS.sh
fi

if [ ! -z "$cron_task" ]; then
    echo "$cron_task /update_TS.sh >> /var/log/cron.log 2>&1" | crontab -
    cron -f >> /var/log/cron.log 2>&1&
    echo " "
    echo "============================================="
    echo "$(date): Cron task set to: $(crontab -l)"
    echo "============================================="
    echo " "
fi

tail -f /dev/null
