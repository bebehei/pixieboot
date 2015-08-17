#!/usr/bin/env bash

DISTRO_NAME=ubuntu-14.04-desktop-rescue

config(){
	echo "label $DISTRO_NAME"
	echo "  menu label Ubuntu 14.04 Desktop rescue"
	echo "  kernel     $BASE_SYSTEMS_rel/$DISTRO_NAME/vmlinuz"
	echo "  append     netboot=nfs rootfstype=nfs4 root=/dev/nfs4 nfsroot=$NFSHOST:$BASE_SYSTEMS/$DISTRO_NAME/ initrd=$BASE_SYSTEMS_rel/$DISTRO_NAME/initrd.img ip=dhcp"

}

installation(){
	mkdir -p $BASE_SYSTEMS/$DISTRO_NAME

	debootstrap --arch=amd64 trusty $BASE_SYSTEMS/$DISTRO_NAME $MIRROR

	for i in dev dev/pts proc sys run; do
		mount -B /$i $BASE_SYSTEMS/$DISTRO_NAME/$i
	done

	echo rescue > $BASE_SYSTEMS/$DISTRO_NAME/etc/hostname

	chroot $BASE_SYSTEMS/$DISTRO_NAME localedef -i de_DE -c -f UTF-8 de_DE.UTF-8 
	chroot $BASE_SYSTEMS/$DISTRO_NAME locale-gen de_DE.UTF-8
	chroot $BASE_SYSTEMS/$DISTRO_NAME locale-gen en_US.UTF-8

	echo "grub-pc	grub-pc/mixed_legacy_and_grub2	boolean	true" | chroot $BASE_SYSTEMS/$DISTRO_NAME debconf-set-selections
	echo "grub-pc	grub-pc/install_devices	multiselect	/dev/null" | chroot $BASE_SYSTEMS/$DISTRO_NAME debconf-set-selections
	echo "grub-pc	grub-pc/install_devices_failed	boolean	true" | chroot $BASE_SYSTEMS/$DISTRO_NAME debconf-set-selections
	chroot $BASE_SYSTEMS/$DISTRO_NAME env DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-desktop vim linux-image-generic

	chroot $BASE_SYSTEMS/$DISTRO_NAME useradd -Um --home-dir /home/user --uid 1000  --password '$6$2ez0KCz3$uBocmB2dW46YyyZPYw78gxkkxWcsRvr3.3hcLujZcjipab8MM6TtQsFqurb7hlVkqCHKbuCKiGsc3OC/wUp/A/' user
	chroot $BASE_SYSTEMS/$DISTRO_NAME usermod -aG adm,cdrom,sudo,plugdev user
	chroot $BASE_SYSTEMS/$DISTRO_NAME sed -i 's/BOOT=local/BOOT=nfs/' /etc/initramfs-tools/initramfs.conf
	chroot $BASE_SYSTEMS/$DISTRO_NAME update-initramfs -u
	chmod 644 $BASE_SYSTEMS/$DISTRO_NAME/boot/vmlinuz-*

	cat > $BASE_SYSTEMS/$DISTRO_NAME/etc/network/interfaces <<-END
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
