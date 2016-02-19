# pixieboot
Repository to bootstrap a PXE server easily. Get in a few steps a working setup to boot over network.

Using dnsmasq to deploy the tftp-server

for deploying the server:
+ check if you have installed dnsmasq
  - `sudo apt-get install dnsmasq dnsmasq-utils`
+ export $NFSHOST (like in config.sh.example)
+ `bash setup.sh`

files:
+ `config/` contains the dnsmasq config file
+ `preseeds/` contains preseeds for the clients
+ `recipes/` contains the network-boot systems
