#!/bin/sh

echo " "
echo "Start checking for updates ..."
[ -d "/TS/updates" ] && rm -r /TS/updates
mkdir -p /TS/updates
wget --output-document=/TS/updates/TorrServer --tries=3 $(curl -s $TS_URL/$TS_RELEASE | grep browser_download_url | egrep -o 'http.+\w+' | grep -i "$(dpkg --print-architecture)" | grep -m 1 -i $LINUX_NAME)
chmod a+x /TS/updates/TorrServer
updated_ver=$(/TS/updates/TorrServer --version)
if [ $? -eq 0 -a ! -z "$updated_ver" ]; then
    current_ver=$(/TS/TorrServer --version)
    if [ "$updated_ver" != "$current_ver" ]; then
        echo "Updating to $updated_ver ..."
        if [ ! -d "/TS/db/backup" ]; then
            mkdir -p /TS/db/backup
        else
            [ -f "/TS/db/backup/TorrServer" ] && rm -f /TS/db/backup/TorrServer
        fi 
        pkill TorrServer
        cp -f /TS/TorrServer /TS/db/backup/
        cp -f /TS/updates/TorrServer /TS/TorrServer
        chmod a+x /TS/TorrServer
        /TS/TorrServer --path=/TS/db/ --port=$TS_PORT&
        sleep 5
        if [ `ps | grep TorrServer | wc -w` -eq 0 ]; then
            echo "Error during the update process: downloaded file is corrupted. Restoring backup."
            rm -f /TS/TorrServer
            cp -f /TS/db/backup/TorrServer /TS/TorrServer
            chmod a+x /TS/TorrServer
            /TS/TorrServer --path=/TS/db/ --port=$TS_PORT&
        fi
    else
        echo "Version $current_ver is latest. No update needed."
    fi
else
    echo "Error during the update process: no internet access or the downloaded file is corrupted."
fi
echo "Finished checking for updates."
echo " "
