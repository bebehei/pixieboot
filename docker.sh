#!/bin/bash

# config.sh-entries
export NFSHOST=${NFSHOST:-$(ip -4 addr show dev eth0 | awk '/inet/{print $2}' | cut -d / -f 1)}

/srv/pixieboot/setup.sh || exit 1

echo "user=root" >> $FILE_DNSMASQ_CONFIG
echo "log-facility=/var/log/dnsmasq.log" >> $FILE_DNSMASQ_CONFIG

service dnsmasq start
service nginx start

tailf /var/log/nginx/pixieboot-access.log &
tailf /var/log/dnsmasq.log &
wait
