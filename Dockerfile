#
# This is unofficial dockerized precompiled TorrServer
#

# For new library glibc >=2.32 use Ubuntu Groovy or newer
# FROM ubuntu:groovy
# FROM debian:stable-slim
FROM ubuntu:latest
MAINTAINER Bob <kcey@mail.ru>

ENV TS_URL=https://releases.yourok.ru/torr/server_release.json
ENV TS_RELEASE="latest"
ENV TS_PORT="8090"
ENV TS_UPDATE="true"
ENV LINUX_UPDATE="true"

ENV GIT_URL=https://api.github.com/repos/YouROK/TorrServer/releases
ENV USER_AGENT="Mozilla/5.0 (X11; Linux x86_64; rv:77.0) Gecko/20100101 Firefox/77.0"

# On linux systems you need to set this environment variable before run:
ENV GODEBUG="madvdontneed=1"

COPY start_TS.sh /start_TS.sh
COPY update_TS.sh /update_TS.sh

RUN export DEBIAN_FRONTEND=noninteractive \
&& chmod a+x /start_TS.sh && chmod a+x /update_TS.sh \
&& apt-get update && apt-get upgrade -y \
&& apt-get install --no-install-recommends -y ca-certificates tzdata wget curl procps cron file jq \
&& apt-get clean \
&& mkdir -p /TS/db && chmod -R 666 /TS/db \
&& wget --no-check-certificate --user-agent="$USER_AGENT" --no-verbose --output-document=/TS/TorrServer --tries=3 $(curl -s $TS_URL | \
   egrep -o 'http.+\w+' | \
   grep -i "$(uname)" | \
   grep -i "$(dpkg --print-architecture | tr -s armhf arm7 | tr -s i386 386)"$) \
&& chmod a+x /TS/TorrServer \
&& touch /var/log/cron.log \
&& ln -sf /proc/1/fd/1 /var/log/cron.log

HEALTHCHECK --interval=5s --timeout=10s --retries=3 CMD curl -sS 127.0.0.1:$TS_PORT || exit 1

VOLUME [ "/TS/db" ]

EXPOSE "$TS_PORT"

ENTRYPOINT ["/start_TS.sh"]
