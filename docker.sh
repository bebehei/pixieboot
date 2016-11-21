#!/bin/bash

# config.sh-entries
export NFSHOST=$(ip -4 addr show dev eth0 | awk '/inet/{print $2}' | cut -d / -f 1)
export FILE_PXE_LINUX=/usr/lib/PXELINUX/pxelinux.0
export SYSTEMS_ENABLED="ubuntu-16.04-mini ubuntu-14.04-mini netboot.xyz memtest local-harddrive"
export FILE_DNSMASQ_CONFIG=/etc/dnsmasq.d/pixieboot.conf

/srv/pixieboot/setup.sh config-write
/srv/pixieboot/setup.sh integrate

echo "user=root" >> $FILE_DNSMASQ_CONFIG

service dnsmasq start
service nginx start

tailf /var/log/nginx/pixieboot-access.log
