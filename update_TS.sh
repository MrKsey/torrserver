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
    
    EXT=$(basename $(wget -nv --spider --no-check-certificate --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:77.0) Gecko/20100101 Firefox/77.0" \
    --content-disposition "$BIP_URL" -O - 2>&1 | \
    egrep -o 'http.+\w+' | cut -f 1 -d " ") | egrep -o '[^.]*$')
    
    wget -nv --no-check-certificate --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:77.0) Gecko/20100101 Firefox/77.0" \
    --content-disposition "$BIP_URL" --output-document=/TS/updates/bip_raw.$EXT
    
    file -b --mime-type bip_raw.$EXT | ( grep -q 'text/plain' && cat bip_raw.$EXT 2>&1 || gunzip -c bip_raw.$EXT) | \
    egrep -v '^#' | tr -d "[:blank:]" | \
    egrep -o '([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}-[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})' | \
    sed -r 's/0*([0-9]+)\.0*([0-9]+)\.0*([0-9]+)\.0*([0-9]+)/\1.\2.\3.\4/g' > /TS/updates/bip.txt
    
    rm -f /TS/updates/bip_raw.$EXT
    
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
wget --no-check-certificate --no-verbose --output-document=/TS/updates/TorrServer --tries=3 $(curl -s $TS_URL | \
egrep -o 'http.+\w+' | \
grep -i "$(uname)" | \
grep -i "$(dpkg --print-architecture | tr -s armhf arm7 | tr -s i386 386)"$)

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
