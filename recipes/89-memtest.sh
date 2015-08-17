#!/usr/bin/env bash

DISTRO_NAME=memtest

config(){
	echo "label $DISTRO_NAME"
	echo "  menu label Memtest"
	echo "  kernel     $BASE_SYSTEMS_rel/$DISTRO_NAME/mt86plus"
}

installation(){
	mkdir -p $BASE_SYSTEMS/$DISTRO_NAME
	cp /boot/memtest86+.bin $BASE_SYSTEMS/$DISTRO_NAME/mt86plus
}

if [[ ! -d $BASE_SYSTEMS/$DISTRO_NAME && -n "$1" && "x$1" == "xinstall" ]]; then
	installation
fi

if [[ -n "$1" && "x$1" == "xconfig" ]]; then
	config
fi
