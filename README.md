# pixieboot

Repository to bootstrap a PXE server easily. Get in a few steps a working setup to boot over network.

It's flexible and programmed modularly. It's easy to use it with existing setups.

## Features 

- dhcp proxy support
  - You can install this in addition to your existing DHCP Server without conflict.
- iPXE for native clients
- iPXE via chainloading for older clients
  - This supports downloading the kernel images via HTTP (way faster than TFTP)
- Fully customizable
  - via [`./config.sh`](./config.sh.example)
  - via [extra integration modules](./integrations)
- installable via [docker](#docker)

### Software used

- dnsmasq (tftp, dhcp proxy)
- nfs-kernel-server (NFS Server)
- nginx
- iPXE and syslinux packages

# Installation

For easy installation, execute

    # install dnsmasq or something else
    cp config.sh.example config.sh
    $EDITOR config.sh
    ./setup.sh

as root. This might seem spooky, but it only does:

- install the system images into the current git-repo
- adding `/etc/dnsmasq.d/pixieboot`
- adding `/etc/exports.d/pixieboot`
- restart of dnsmasq and nfs-kernel-server

## setup.sh

    ./setup.sh [PARAMETER]

    PARAMETER can be of:

    system-install   Install and configure
    config-write     Write (or update) PXE configuration file
    integrate        Configure system-services to use pixieboot for PXE-boot

    If PARAMETER is omitted, setup.sh will do everything (integration, install the systems, write config)

# Folder structure

<dl>
  <dt>integrations</dt><dd>scripts to integrate services to use pixieboot</dd>
  <dt>recipes</dt><dd>the actual scripts, installing the systems</dd>
  <dt>systems</dt><dd>filesystem-roots of all bootable systems</dd>
</dl>

# Modular system

The system is kept fully modular. You can easily add new bootable
systems or use another TFTP/DHCP server combination.

## Adding another system

For adding a new system, you have to create a new so-called recipe.
The recipe is a script, containing information for downloading,
installing and configuring a new system-chroot.

This recipe should be stored inside the recipes folder and respond
to the parameters `install` or `config`.

Executed with the `config`-parameter it should print on STDOUT
its configuration to put into PXELINUX config.

Executed with the `install`-parameter it should install its system
into folder of given environment-variable `$BASE_SYSTEMS/$DISTRO_NAME`.
Your recipe should not execute anything if the system seems to be
installed already. If it's not installed properly, a manual remove by
the user should be neccessary.

I could write 1000s of words here. But it might now be the best for you,
to look at the `recipes`-folder and look, what these scripts do there.
Most of the work, for adding new recipes, is just copy and paste.

## Using different TFTP or DHCP Servers

1. Create a new integration file:
   1. Add an executable file to `integrations/`
   2. The file should integrate pixieboot into the software configuration.
   3. Subsequent calls of this file should not emit bad configuration files.
   4. Available environment-variables are listed in `config.sh`
2. Change in `config.sh` the value of `INTEGRATIONS_ENABLED` to include your
   new integration.
3. Execute `./setup.sh integrate`.

# Docker

You have to use the docker host-network, as DHCP is not usable via port-forwarding.

Also define the env-variable NFSHOST to match your local IP-Address. Additionally,
you must not run a service on port 80, 67 or 53 on your host system.

    docker run \
      -h pixieboot \
      --name pixieboot \
      --env NFSHOST=<EXTERNAL_IP_ADDRESS> \
      --net=host \
      --detach \
      bebehei/pixieboot:latest
