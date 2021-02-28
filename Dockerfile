#
# This is unofficial dockerized precompiled TorrServer
#

FROM debian:stable-slim
MAINTAINER Bob <kcey@mail.ru>

ENV TS_URL=https://api.github.com/repos/YouROK/TorrServer/releases
ENV TS_RELEASE="latest"
ENV OS="linux"
ENV TS_PORT="8090"

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get update && apt-get upgrade -y \
&& apt-get install --no-install-recommends -y ca-certificates wget curl \
&& mkdir -p /TS/db && chmod -R 666 /TS/db && cd /TS \
&& wget --output-document=TorrServer --tries=3 $(curl -s $TS_URL/$TS_RELEASE | \
   grep browser_download_url | \
   egrep -o 'http.+\w+' | \
   grep -i "$(dpkg --print-architecture)" | \
   grep -m 1 -i $OS) \
&& chmod a+x ./TorrServer \
&& apt-get purge -y -q --auto-remove ca-certificates wget curl \
&& apt-get clean \
&& cd / \
&& rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/* \

VOLUME [ "/TS/db" ]

EXPOSE "$TS_PORT"

ENTRYPOINT ["/TS/TorrServer"]
CMD ["--path", "/TS/db/", "--port", "$TS_PORT"]
