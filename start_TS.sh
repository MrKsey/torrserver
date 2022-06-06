#!/bin/sh

# Folder for disk cache
[ ! -d "$TS_TORR_DIR" ] && mkdir -p $TS_TORR_DIR && chmod -R 777 $TS_TORR_DIR
ln -s $TS_TORR_DIR /torrents && rm $TS_TORR_DIR/torrents

# Configuration file ts.ini source. Do not change!
export INI_URL="https://raw.githubusercontent.com/MrKsey/torrserver/main/ts.ini"
if [ ! -e $TS_CONF_PATH/ts.ini ]; then
    wget -q --no-check-certificate --user-agent="$USER_AGENT" --content-disposition "$INI_URL" -O $TS_CONF_PATH/ts.ini
    if [ -e $TS_CONF_PATH/ts.ini ]; then
        echo " "
        echo "============================================="
        echo "$(date): File $TS_CONF_PATH/ts.ini downloaded from the github."
        echo "============================================="
        echo " "
    fi
fi

if [ -e $TS_CONF_PATH/ts.ini ]; then
    chmod a+r $TS_CONF_PATH/ts.ini
    sed -i -e "s/\r//g" $TS_CONF_PATH/ts.ini
    . $TS_CONF_PATH/ts.ini && export $(grep --regexp ^[a-zA-Z] $TS_CONF_PATH/ts.ini | cut -d= -f1)
    echo "============================================="
    echo "$(date): Configuration settings from ts.ini file:"
    echo " "
    echo "$(cat $TS_CONF_PATH/ts.ini | grep --regexp ^[a-zA-Z])"
    echo " "
    echo "============================================="
    echo " "
fi

# File accs.db source. Do not change!
export ACCS_URL="https://raw.githubusercontent.com/MrKsey/torrserver/main/accs.db"
if [ ! -e $TS_CONF_PATH/accs.db ]; then
    wget -q --no-check-certificate --user-agent="$USER_AGENT" --content-disposition "$ACCS_URL" -O $TS_CONF_PATH/accs.db
    if [ -e $TS_CONF_PATH/accs.db ]; then
        echo " "
        echo "============================================="
        echo "$(date): File $TS_CONF_PATH/accs.db downloaded from the github."
        echo "============================================="
        echo " "
    fi
fi

# File config.db source. Do not change!
export CONFIG_URL="https://raw.githubusercontent.com/MrKsey/torrserver/main/config.db"
if [ ! -e $TS_CONF_PATH/config.db ]; then
    wget -q --no-check-certificate --user-agent="$USER_AGENT" --content-disposition "$CONFIG_URL" -O $TS_CONF_PATH/config.db
    if [ -e $TS_CONF_PATH/config.db ]; then
        echo " "
        echo "============================================="
        echo "$(date): File $TS_CONF_PATH/config.db downloaded from the github."
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
/TS/TorrServer --path=$TS_CONF_PATH/ --torrentsdir=$TS_TORR_DIR --port=$TS_PORT $TS_OPTIONS &
sleep 5
if [ `ps | grep TorrServer | wc -w` -eq 0 ]; then
    echo "Current TorrServer file is corrupted or invalid options. Trying to recover."
    /TS/TorrServer --path=$TS_CONF_PATH/ --torrentsdir=$TS_TORR_DIR --port=$TS_PORT &
    if [ `ps | grep TorrServer | wc -w` -eq 0 ]; then
        if [ -e $TS_CONF_PATH/backup/TorrServer ]; then
            rm -f /TS/TorrServer
            cp -f $TS_CONF_PATH/backup/TorrServer /TS/TorrServer
            chmod a+x /TS/TorrServer
            /TS/TorrServer --path=$TS_CONF_PATH/ --torrentsdir=$TS_TORR_DIR --port=$TS_PORT &
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

[ "$TS_RELEASE" != "latest" ] && [ $(curl -Is $GIT_URL/tags/$TS_RELEASE | head -n 1 | egrep -o '[0-9]{3}') -eq 200 ] && export TS_URL=$GIT_URL/tags/$TS_RELEASE

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
