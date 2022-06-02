#
# This is unofficial dockerized precompiled TorrServer
#

FROM ubuntu:latest
MAINTAINER Bob <kcey@mail.ru>

ENV TS_URL=https://releases.yourok.ru/torr/server_release.json
ENV TS_RELEASE="latest"
ENV TS_PORT="8090"
ENV TS_UPDATE="true"
ENV LINUX_UPDATE="true"

ENV TS_CONF_PATH=/TS/db
ENV TS_TORR_DIR=/TS/db/torrents

ENV GIT_URL=https://api.github.com/repos/YouROK/TorrServer/releases
ENV FFBINARIES="https://ffbinaries.com/api/v1/version/latest"
ENV USER_AGENT="Mozilla/5.0 (X11; Linux x86_64; rv:77.0) Gecko/20100101 Firefox/77.0"

# On linux systems you need to set this environment variable before run:
ENV GODEBUG="madvdontneed=1"

COPY start_TS.sh /start_TS.sh
COPY update_TS.sh /update_TS.sh

RUN export DEBIAN_FRONTEND=noninteractive \
&& chmod a+x /start_TS.sh && chmod a+x /update_TS.sh \
&& apt-get update && apt-get upgrade -y \
&& apt-get install --no-install-recommends -y ca-certificates tzdata wget curl procps cron file jq unzip \
&& apt-get clean \
&& mkdir /TS && chmod -R 666 /TS \
&& mkdir -p $TS_CONF_PATH && chmod -R 666 $TS_CONF_PATH \
&& wget --no-check-certificate --user-agent="$USER_AGENT" --no-verbose --output-document=/TS/TorrServer --tries=3 $(curl -s $TS_URL | \
   egrep -o 'http.+\w+' | \
   grep -i "$(uname)" | \
   grep -i "$(dpkg --print-architecture | tr -s armhf arm7 | tr -s i386 386)"$) \
&& chmod +x /TS/TorrServer \
&& wget --no-verbose --no-check-certificate --user-agent="$USER_AGENT" --output-document=/tmp/ffprobe.zip --tries=3 $(\
   curl -s $FFBINARIES | jq '.bin | .[].ffprobe' | grep linux | \
   grep -i -E "$(dpkg --print-architecture | sed "s/amd64/linux-64/g" | sed "s/arm64/linux-arm-64/g" | sed -E "s/armhf/linux-armhf-32/g")" | jq -r) \
&& unzip -x -o /tmp/ffprobe.zip ffprobe -d /usr/local/bin \
&& chmod -R +x /usr/local/bin \
&& touch /var/log/cron.log \
&& ln -sf /proc/1/fd/1 /var/log/cron.log

HEALTHCHECK --interval=5s --timeout=10s --retries=3 CMD curl -sS 127.0.0.1:$TS_PORT || exit 1

VOLUME [ "$TS_CONF_PATH" ]

EXPOSE "$TS_PORT"

ENTRYPOINT ["/start_TS.sh"]
