#!/bin/bash

function update {
  apt-get update && apt-get upgrade
}


function install_alfa_drivers {
  apt-get remove realtek-rtl88xxau-dkms
  apt-get purge realtek-rtl88xxau-dkms
  apt-get install realtek-rtl88xxau-dkms
}


function install_setup_hostapd_wpe {
  apt-get install libssl-dev libnl-genl-3-dev
  git clone https://github.com/OpenSecurityResearch/hostapd-wpe
  wget http://hostap.epitest.fi/releases/hostapd-2.6.tar.gz
  tar -zxf hostapd-2.6.tar.gz
  cd hostapd-2.6
  patch -p1 < ../hostapd-wpe/hostapd-wpe.patch 
  cd hostapd
  make
  cd ../../hostapd-wpe/certs
  ./bootstrap
  cd ../../hostapd-2.6/hostapd
  sudo ./hostapd-wpe hostapd-wpe.conf
}


function setup_sshd {
  echo "Setting up SSH Daemon"
  apt-get install openssh-server
  printf "PubkeyAuthentication yes \nPasswordAuthentication no " >> ./etc/ssh/sshd_config
}


update
install_setup_hostapd_wpe
setup_sshd
