#!/usr/bin/env bash

DISTRO_NAME=ubuntu-14.04-desktop-rescue

config(){
	echo "label $DISTRO_NAME"
	echo "  menu label Ubuntu 14.04 Desktop rescue"
	echo "  kernel     systems/$DISTRO_NAME/vmlinuz"
	echo "  append     netboot=nfs rootfstype=nfs4 root=/dev/nfs4 nfsroot=$NFSHOST:$BASE_SYSTEMS/$DISTRO_NAME/ initrd=$BASE_SYSTEMS_rel/$DISTRO_NAME/initrd.img ip=dhcp"

}

installation(){
	mkdir -p $BASE_SYSTEMS/$DISTRO_NAME

	debootstrap --arch=amd64 trusty $BASE_SYSTEMS/$DISTRO_NAME $MIRROR

	for i in /dev /dev/pts /proc /sys /run; do 
		mount -B $i $BASE_SYSTEMS/$DISTRO_NAME $i
	done 

	echo rescue > $BASE_SYSTEMS/$DISTRO_NAME/etc/hostname

	chroot $BASE_SYSTEMS/$DISTRO_NAME localedef -i de_DE -c -f UTF-8 de_DE.UTF-8 
	chroot $BASE_SYSTEMS/$DISTRO_NAME apt-get install linux-image-generic ubuntu-desktop vim
	chroot $BASE_SYSTEMS/$DISTRO_NAME useradd -Um --home-dir /home/user --uid 1000  --password '$6$2ez0KCz3$uBocmB2dW46YyyZPYw78gxkkxWcsRvr3.3hcLujZcjipab8MM6TtQsFqurb7hlVkqCHKbuCKiGsc3OC/wUp/A/'
	chroot $BASE_SYSTEMS/$DISTRO_NAME usermod -aG adm,cdrom,sudo,plugdev,lpadmin user
	chroot $BASE_SYSTEMS/$DISTRO_NAME sed 's/BOOT=local/BOOT=nfs/' /etc/initramfs-tools/initramfs.conf
	chroot $BASE_SYSTEMS/$DISTRO_NAME update-initramfs -u
	chroot $BASE_SYSTEMS/$DISTRO_NAME cat <<-END
	auto lo
	iface lo inet loopback

	auto eth0
	iface eth0 inet manual
	END
}

if [[ ! -d $BASE_SYSTEMS/$DISTRO_NAME && -n "$1" && "x$1" == "xinstall" ]]; then
	installation
fi

if [[ -n "$1" && "x$1" == "xconfig" ]]; then
	config
fi
