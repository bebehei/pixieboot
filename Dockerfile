FROM ubuntu:16.04
MAINTAINER Benedikt Heine bebe@bebehei.de

# ENVs are neccessary in docker.sh, too
ENV NFSHOST=127.0.0.1
ENV SYSTEMS_ENABLED="local-harddrive netboot.xyz memtest ubuntu-14.04-mini ubuntu-16.04-mini"
ENV FILE_PXE_LINUX=/usr/lib/PXELINUX/pxelinux.0
ENV FILE_DNSMASQ_CONFIG=/etc/dnsmasq.d/pixieboot.conf
ENV BASE=/srv/pixieboot

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

RUN /srv/pixieboot/setup.sh

EXPOSE 67/udp 80/tcp

ENTRYPOINT ["/srv/pixieboot/docker.sh"]
