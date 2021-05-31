#!/bin/sh

if [ -e /TS/cron.env ]; then
    set -a; . /TS/cron.env; set +a
fi

[ -d /TS/updates ] && rm -r /TS/updates
mkdir -p /TS/updates

if [ ! -z "$BIP_URL" ]; then
    echo " "
    echo "=================================================="
    echo "$(date): Start checking for blacklist ip updates ..."
    wget -q --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:77.0) Gecko/20100101 Firefox/77.0" --content-disposition "$BIP_URL" -O - | gunzip | egrep -v '^#' > /TS/updates/bip.txt
    bip_size=$(wc -l /TS/updates/bip.txt | cut -f 1 -d ' ')
    if [ $bip_size -gt 0 ]; then
        cp -f /TS/updates/bip.txt /TS/db/bip.txt
        chmod a+r /TS/db/bip.txt
        echo "New bip.txt size: $bip_size strings. Restarting TorrServer..."
        pkill TorrServer
        /TS/TorrServer --path=/TS/db/ --port=$TS_PORT $TS_OPTIONS &
    else
        echo "Error updating blacklist ip from URL - $BIP_URL"
    fi
    echo "Finished checking for updates."
    echo "=================================================="
    echo " "
fi

echo " "
echo "=================================================="
echo "$(date): Start checking for TorrServer updates ..."
wget --no-verbose --output-document=/TS/updates/TorrServer --tries=3 $(curl -s $TS_URL/$TS_RELEASE | grep browser_download_url | egrep -o 'http.+\w+' | grep -i "$(dpkg --print-architecture)" | grep -m 1 -i $LINUX_NAME)
chmod a+x /TS/updates/TorrServer
updated_ver=$(/TS/updates/TorrServer --version)
if [ $? -eq 0 -a ! -z "$updated_ver" ]; then
    current_ver=$(/TS/TorrServer --version)
    if [ "$updated_ver" != "$current_ver" ]; then
        echo "Updating to $updated_ver ..."
        if [ ! -d /TS/db/backup ]; then
            mkdir -p /TS/db/backup
        else
            [ -e /TS/db/backup/TorrServer ] && rm -f /TS/db/backup/TorrServer
        fi 
        pkill TorrServer
        cp -f /TS/TorrServer /TS/db/backup/
        cp -f /TS/updates/TorrServer /TS/TorrServer
        chmod a+x /TS/TorrServer
        /TS/TorrServer --path=/TS/db/ --port=$TS_PORT $TS_OPTIONS &
        sleep 5
        if [ `ps | grep TorrServer | wc -w` -eq 0 ]; then
            echo "Error during the update process: downloaded file is corrupted. Restoring backup."
            rm -f /TS/TorrServer
            cp -f /TS/db/backup/TorrServer /TS/TorrServer
            chmod a+x /TS/TorrServer
            /TS/TorrServer --path=/TS/db/ --port=$TS_PORT $TS_OPTIONS &
        fi
    else
        echo "Version $current_ver is latest. No update needed."
    fi
else
    echo "Error during the update process: no internet access or the downloaded file is corrupted."
fi
echo "Finished checking for updates."
echo "=================================================="
echo " "
