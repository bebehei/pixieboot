#!/usr/bin/env bash

DISTRO_NAME=archlinux-nfs

config(){
	echo "label $DISTRO_NAME"
	echo "  menu label ^ArchLinux NFS"
	echo "  kernel     $BASE_SYSTEMS_rel/$DISTRO_NAME/root.x86_64/boot/vmlinuz-linux"
	# we need the fall-back-image, cause we use different hardware. E.g. the network-card is not recognized on other computers with the normal image
	echo "  append     nfsroot=$NFSHOST:$BASE_SYSTEMS/$DISTRO_NAME/root.x86_64/ initrd=$BASE_SYSTEMS_rel/$DISTRO_NAME/root.x86_64/boot/initramfs-linux-fallback.img ip=:::::eth0:dhcp"
}

installation(){
	mkdir -p $BASE_SYSTEMS/$DISTRO_NAME
	# most things are taken from https://github.com/bebehei/archinstall/ (Benedikt Heine's repository to install archlinux easily)
	new_lc_all=C
	new_hostname=archlinux-rescue-nfs
	new_basepkg=(base base-devel grub vim git openssh mkinitcpio-nfs-utils linux nfs-utils nfsidmap)
	new_mirror='http://mirror.selfnet.de/archlinux/$repo/os/$arch'
	new_tz="Europe/Berlin"

	# static variables. edit, if neccessary
	mountpoint=$BASE_SYSTEMS/$DISTRO_NAME/root.x86_64
	#CHR=$mountpoint/bin/arch-chroot
	CHR=chroot

	function chr(){
		for i in dev dev/pts proc sys run; do
			mount -B /$i $mountpoint/$i
		done

		mkdir -p /run/shm # correct debian-based hosts
		$CHR $mountpoint $*

		for i in dev/pts dev proc sys run; do
			# do it lazy, cause otherwise the gpg-agent would stop everything
			umount -l $mountpoint/$i
		done
	}

	wget $(echo $new_mirror | sed 's%\$repo/os/\$arch%iso%')/$(date +%Y.%m.01)/archlinux-bootstrap-$(date +%Y.%m.01)-x86_64.tar.gz -O - | tar xz -C $BASE_SYSTEMS/$DISTRO_NAME

	# real script starts here
	# set server to preferred mirror
	echo "Server = $new_mirror" > $mountpoint/etc/pacman.d/mirrorlist

	# base-installation according to Arch-Wiki
	echo $new_hostname > $mountpoint/etc/hostname
	chr ln -sf /usr/share/zoneinfo/$new_tz /etc/localtime
	echo $new_lc > $mountpoint/etc/locale.gen
	chr locale-gen
	echo LC_ALL=$_new_lc_all >> $mountpoint/etc/locale.conf

	echo init
	CONFIG= chr pacman-key --init
	echo populate
	CONFIG= chr pacman-key --populate archlinux
	CONFIG= chr pacman -Sy
	CONIFG= chr pacman -S --noconfirm --needed ${new_basepkg[@]}

	#Edit $root/etc/mkinitcpio.conf and add nfsv4 to MODULES, net_nfs4 to HOOKS, and /usr/bin/mount.nfs4 to BINARIES
	sed 's/nfsmount/mount.nfs4/' $mountpoint/usr/lib/initcpio/hooks/net > "$mountpoint/usr/lib/initcpio/hooks/net_nfs4"
	cp $mountpoint/usr/lib/initcpio/install/net{,_nfs4}
	sed -i 's%MODULES="\(.*\)"%MODULES="\1 nfsv4"%;s%HOOKS="\(.*\)"%HOOKS="\1 net net_nfs4"%;s%BINARIES="\(.*\)"%BINARIES="\1 /usr/bin/mount.nfs4"%' $mountpoint/etc/mkinitcpio.conf
	chr mkinitcpio -p linux

	# network, sshd, resolved
	chr systemctl enable sshd systemd-networkd systemd-resolved

	# assemble the network-configuration
	netfile=/etc/systemd/network/50-main.network
	echo '# Archinstall config-script defaults!' > $mountpoint$netfile
	echo '[Match]' >> $mountpoint$netfile
	echo 'Name=e*' >> $mountpoint$netfile
	echo '[Network]' >> $mountpoint$netfile
	echo 'DHCP=yes' >> $mountpoint$netfile
	rm $mountpoint/etc/resolv.conf
	chr ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
}

if [[ ! -d $BASE_SYSTEMS/$DISTRO_NAME && -n "$1" && "x$1" == "xinstall" ]]; then
	installation
fi

if [[ -n "$1" && "x$1" == "xconfig" ]]; then
	config
fi
