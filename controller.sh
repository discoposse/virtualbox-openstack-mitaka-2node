#!/bin/bash

#  controller.sh

# Authors: Eric Wright (@DiscoPosse)

export DEBIAN_FRONTEND=noninteractive
echo "set grub-pc/install_devices /dev/sda" | debconf-communicate

sudo apt-get update && sudo apt-get upgrade -y 
sudo apt-get install -y git vim openssh-server software-properties-common python-pip 
sudo add-apt-repository cloud-archive:mitaka
sudo apt-get update
sudo reboot
