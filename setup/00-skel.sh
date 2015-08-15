#!/usr/bin/env bash

# copy this file for your new state

DISTRO_NAME=skelleton

config(){
	# here will be the config printed.
	# uncomment and adapt the entries
	#echo "label $DISTRO_NAME"
	#echo "  menu label Ubuntu 14.04 Desktop rescue"
	#echo "  kernel     systems/$DISTRO_NAME/vmlinuz"
	#echo "  append     netboot=nfs rootfstype=nfs4 root=/dev/nfs4 nfsroot=$NFSHOST:$BASE_SYSTEMS/$DISTRO_NAME/ initrd=$BASE_SYSTEMS_rel/$DISTRO_NAME/initrd.img ip=dhcp"
}

installation(){
	# always do this at first. When setup.sh is called again, it will detect, that this system is already installed and won't do the effort again.
	mkdir -p $BASE_SYSTEMS/$DISTRO_NAME
}

if [[ ! -d $BASE_SYSTEMS/$DISTRO_NAME && -n "$1" && "x$1" == "xinstall" ]]; then
	installation
fi

if [[ -n "$1" && "x$1" == "xconfig" ]]; then
	config
fi
