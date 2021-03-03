#!/bin/sh

[ -d /TS/updates ] && rmdir --ignore-fail-on-non-empty /TS/updates
mkdir -p /TS/updates
wget --output-document=/TS/updates/TorrServer --tries=3 $(curl -s $TS_URL/$TS_RELEASE | grep browser_download_url | egrep -o 'http.+\w+' | grep -i "$(dpkg --print-architecture)" | grep -m 1 -i $LINUX_NAME)
chmod a+x /TS/updates/TorrServer
updated_ver=$(/TS/updates/TorrServer --version)
if [ $? -eq 0 -a ! -z "$updated_ver" ]; then
    current_ver=$(/TS/TorrServer --version)
    if [ "$updated_ver" != "$current_ver" ]; then
        echo "Updating to $updated_ver ..."
        pkill TorrServer
        [ -d /TS/backup ] && rmdir --ignore-fail-on-non-empty /TS/backup
        mkdir -p /TS/backup
        cp -f /TS/TorrServer /TS/backup/
        cp -f /TS/updates/TorrServer /TS/TorrServer
        chmod a+x /TS/TorrServer
        /TS/TorrServer --path=/TS/db/ --port=$TS_PORT&
    fi
fi
