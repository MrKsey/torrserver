#!/bin/sh

# Sleep a random number of seconds before executing a task (1 - 40 sec.)
sleep $((RANDOM % 40))

if [ -e /TS/cron.env ]; then
    set -a; . /TS/cron.env; set +a
fi

[ -d /TS/updates ] && rm -r /TS/updates
mkdir -p /TS/updates


# Start checking for ffprobe updates
echo " "
echo "=================================================="
echo "$(date): Start checking for ffprobe updates ..."

wget --no-verbose --no-check-certificate --user-agent="$USER_AGENT" --output-document=/tmp/ffprobe.zip --tries=3 $(\
curl -s $FFBINARIES | jq '.bin | .[].ffprobe' | grep linux | \
grep -i -E "$(dpkg --print-architecture | sed "s/amd64/linux-64/g" | sed "s/arm64/linux-arm-64/g" | sed -E "s/armhf/linux-armhf-32/g")" | jq -r)
unzip -x -o /tmp/ffprobe.zip ffprobe -d /usr/local/bin
chmod -R +x /usr/local/bin
echo " "
ffprobe -version
echo " "
echo "Finished checking for ffprobe updates."
echo "=================================================="
echo " "


# Start checking for blacklist ip updates
if [ ! -z "$BIP_URL" ]; then
    echo " "
    echo "=================================================="
    echo "$(date): Start checking for blacklist ip updates ..."
    
    cd /TS/updates
    
    EXT=$(basename $(wget -nv --spider --no-check-certificate --user-agent="$USER_AGENT" \
    --content-disposition "$BIP_URL" -O - 2>&1 | egrep -o 'http.+\w+' | cut -f 1 -d " ") | egrep -o '[^.]*$')
    
    wget -nv --no-check-certificate --user-agent="$USER_AGENT" \
    --content-disposition "$BIP_URL" --output-document=bip_raw.$EXT
    
    file -b --mime-type bip_raw.$EXT | ( grep -q 'text/plain' && cat bip_raw.$EXT 2>&1 || gunzip -c bip_raw.$EXT) | \
    egrep -v '^#' | tr -d "[:blank:]" | \
    awk '{gsub("[a-zA-Z][0-9]+\.[0-9]+\.[0-9]+\.[0-9]+","");print}' | \
    awk '{gsub("[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+[a-zA-Z]","");print}' | \
    egrep -o '([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}-[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})' | \
    sed -r 's/0*([0-9]+)\.0*([0-9]+)\.0*([0-9]+)\.0*([0-9]+)/\1.\2.\3.\4/g' | \
    egrep -v '^(0|22[4-9]|2[3-5]|192\.168\.[0-9]{1,3}\.[0-9]{1,3})' | \
    sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n -u > bip.txt
    
    rm -f bip_raw.$EXT
    
    bip_size=$(wc -l bip.txt | cut -f 1 -d ' ')
    if [ $bip_size -gt 0 ]; then
        cp -f /TS/updates/bip.txt $TS_CONF_PATH/bip.txt
        chmod a+r $TS_CONF_PATH/bip.txt
        echo "New bip.txt size: $bip_size strings. Restarting TorrServer..."
        pkill TorrServer
        cd $TS_TORR_DIR
        /TS/TorrServer --path=$TS_CONF_PATH/ --torrentsdir=$TS_TORR_DIR --port=$TS_PORT $TS_OPTIONS &
    else
        echo "Error updating blacklist ip from URL - $BIP_URL"
    fi
    echo "Finished checking for blacklist ip updates."
    echo "=================================================="
    echo " "
fi


# Start checking for TorrServer updates
echo " "
echo "=================================================="
echo "$(date): Start checking for TorrServer updates ..."
wget --no-check-certificate --no-verbose --user-agent="$USER_AGENT" --output-document=/TS/updates/TorrServer --tries=3 $(curl -s $TS_URL | \
egrep -o 'http.+\w+' | \
grep -i "$(uname)" | \
grep -i "$(dpkg --print-architecture | tr -s armhf arm7 | tr -s i386 386)"$)

chmod a+x /TS/updates/TorrServer
updated_ver=$(/TS/updates/TorrServer --version)
if [ $? -eq 0 -a ! -z "$updated_ver" ]; then
    current_ver=$(/TS/TorrServer --version)
    if [ "$updated_ver" != "$current_ver" ]; then
        echo "Updating to $updated_ver ..."
        if [ ! -d $TS_CONF_PATH/backup ]; then
            mkdir -p $TS_CONF_PATH/backup
        else
            [ -e $TS_CONF_PATH/backup/TorrServer ] && rm -f $TS_CONF_PATH/backup/TorrServer
        fi
        pkill TorrServer
        cp -f /TS/TorrServer $TS_CONF_PATH/backup/
        cp -f /TS/updates/TorrServer /TS/TorrServer
        chmod a+x /TS/TorrServer
        /TS/TorrServer --path=$TS_CONF_PATH/ --torrentsdir=$TS_TORR_DIR --port=$TS_PORT $TS_OPTIONS &
        sleep 5
        if [ `ps | grep TorrServer | wc -w` -eq 0 ]; then
            echo "Error during the update process: downloaded file is corrupted. Restoring backup."
            rm -f /TS/TorrServer
            cp -f $TS_CONF_PATH/backup/TorrServer /TS/TorrServer
            chmod a+x /TS/TorrServer
            /TS/TorrServer --path=$TS_CONF_PATH/ --torrentsdir=$TS_TORR_DIR --port=$TS_PORT $TS_OPTIONS &
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
