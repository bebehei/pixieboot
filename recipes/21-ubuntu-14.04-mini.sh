#!/usr/bin/env bash

DISTRO_NAME=ubuntu-14.04-mini

config(){
	echo "label $DISTRO_NAME"
	echo "  menu label Ubuntu 14.04 M^ini"
	echo "  kernel     $BASE_SYSTEMS_rel/$DISTRO_NAME/linux"
	echo "  append     boot=casper netboot=nfs nfsroot=$NFSHOST:$BASE_SYSTEMS/$DISTRO_NAME/ initrd=$BASE_SYSTEMS_rel/$DISTRO_NAME/initrd.gz"

	echo "label $DISTRO_NAME-preseed-default"
	echo "  menu label Install Ubuntu 14.04 ^Server"
	echo "  kernel     $BASE_SYSTEMS_rel/$DISTRO_NAME/linux"
	echo "  append     boot=casper netboot=nfs nfsroot=$NFSHOST:$BASE_SYSTEMS/$DISTRO_NAME/ initrd=$BASE_SYSTEMS_rel/$DISTRO_NAME/initrd.gz priority=critical interface=auto locale=en_US.UTF-8 preseed/url=tftp://$NFSHOST/preseeds/server.cfg"

	echo "label $DISTRO_NAME-preseed-default"
	echo "  menu label Install Ubuntu 14.04 ^Desktop"
        echo "  kernel     $BASE_SYSTEMS_rel/$DISTRO_NAME/linux"
	echo "  append     boot=casper netboot=nfs nfsroot=$NFSHOST:$BASE_SYSTEMS/$DISTRO_NAME/ initrd=$BASE_SYSTEMS_rel/$DISTRO_NAME/initrd.gz priority=critical interface=auto locale=en_US.UTF-8 preseed/url=tftp://$NFSHOST/preseeds/desktop.cfg"

}

installation(){
	iso=$(mktemp)
	dir=$(mktemp -d)
	wget http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/mini.iso -O $iso
	mount $iso $dir
	cp -r $dir $BASE_SYSTEMS/$DISTRO_NAME
	umount $dir
	rmdir $dir
	rm $iso
}

if [[ ! -d $BASE_SYSTEMS/$DISTRO_NAME && -n "$1" && "x$1" == "xinstall" ]]; then
	installation
fi

if [[ -n "$1" && "x$1" == "xconfig" ]]; then
	config
fi
