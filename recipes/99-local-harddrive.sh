#!/usr/bin/env bash

DISTRO_NAME=localhdd1

config(){
	echo "label $DISTRO_NAME"
	echo "  menu label Local ^HDD"
	echo "  localboot 0"
}

installation(){
	return 0
}

if [[ ! -d $BASE_SYSTEMS/$DISTRO_NAME && -n "$1" && "x$1" == "xinstall" ]]; then
	installation
fi

if [[ -n "$1" && "x$1" == "xconfig" ]]; then
	config
fi
