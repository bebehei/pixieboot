FROM ubuntu:16.04
MAINTAINER Benedikt Heine bebe@bebehei.de

ENV BASE=/srv/pixieboot

# Vars, which would be usually defined in config.sh
ENV INTEGRATIONS_ENABLED="dnsmasq nginx pxebinaries"
ENV SYSTEMS_ENABLED="ubuntu-16.04-mini ubuntu-14.04-mini netboot.xyz memtest local-harddrive"
ENV FILE_PXE_LINUX=/usr/lib/PXELINUX/pxelinux.0
ENV FILE_DNSMASQ_CONFIG=/etc/dnsmasq.d/pixieboot.conf
# Set the reload commands to true, as normal service-commands would fail
# and docker.sh is starting the services anyway
ENV CMD_RELOAD_NGINX="true"
ENV CMD_RELOAD_DNSMASQ="true"

RUN apt-get update \
  && apt-get install -y \
    dnsmasq \
    gettext-base \
    ipxe \
    memtest86+ \
    nginx \
    pxelinux \
    wget \
    xorriso \
  && rm -rf /var/lib/apt/lists/*

ADD . $BASE

# We have to define NFSHOST, as it is needed by setup.sh,
# but declaring it via ENV lets the container fail quietly.
RUN NFSHOST=127.0.0.1 /srv/pixieboot/setup.sh

EXPOSE 67/udp 80/tcp

ENTRYPOINT ["/srv/pixieboot/docker.sh"]
