#
# This is unofficial dockerized precompiled TorrServer
#

# For new library glibc >=2.32 use Ubuntu Groovy or newer
# FROM ubuntu:groovy
FROM debian:stable-slim
MAINTAINER Bob <kcey@mail.ru>

# On linux systems you need to set this environment variable before run:
ENV GODEBUG="madvdontneed=1"

ENV TS_URL=https://api.github.com/repos/YouROK/TorrServer/releases
ENV TS_RELEASE="latest"
ENV TS_PORT="8090"
ENV TS_UPDATE="true"
ENV LINUX_NAME="linux"
ENV LINUX_UPDATE="true"

COPY start_TS.sh /start_TS.sh
COPY update_TS.sh /update_TS.sh

RUN export DEBIAN_FRONTEND=noninteractive \
&& chmod a+x /start_TS.sh && chmod a+x /update_TS.sh \
&& apt-get update && apt-get upgrade -y \
&& apt-get install --no-install-recommends -y ca-certificates tzdata wget curl procps cron \
&& apt-get clean \
&& mkdir -p /TS/db && chmod -R 666 /TS/db \
&& wget --no-verbose --output-document=/TS/TorrServer --tries=3 $(curl -s $TS_URL/$TS_RELEASE | \
   grep browser_download_url | \
   egrep -o 'http.+\w+' | \
   grep -i "$(dpkg --print-architecture)" | \
   grep -m 1 -i $LINUX_NAME) \
&& chmod a+x /TS/TorrServer \
&& touch /var/log/cron.log \
&& ln -sf /proc/1/fd/1 /var/log/cron.log

HEALTHCHECK --interval=5s --timeout=10s --retries=3 CMD curl -sS 127.0.0.1:8090 || exit 1

VOLUME [ "/TS/db" ]

EXPOSE "$TS_PORT"

ENTRYPOINT ["/start_TS.sh"]
