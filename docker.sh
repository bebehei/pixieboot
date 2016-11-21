#!/bin/bash

# config.sh-entries
export NFSHOST=${NFSHOST:-$(ip -4 addr show dev eth0 | awk '/inet/{print $2}' | cut -d / -f 1)}

/srv/pixieboot/setup.sh config-write || exit 1
/srv/pixieboot/setup.sh integrate || exit 1

echo "user=root" >> $FILE_DNSMASQ_CONFIG

service dnsmasq start
service nginx start

tailf /var/log/nginx/pixieboot-access.log
