#!/bin/bash

#########################################
## ENVIRONMENTAL CONFIG                ##
#########################################

# Configure user nobody to match unRAID's settings
usermod -u 99 nobody
usermod -g 100 nobody
usermod -d /home nobody
chown -R nobody:users /home

# Disable SSH
#rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Fix the timezone
#if [[ $(cat /etc/timezone) != $TZ ]] ; then
#echo "$TZ" > /etc/timezone
#dpkg-reconfigure -f noninteractive tzdata
#fi

#########################################
## REPOSITORIES AND DEPENDENCIES       ##
#########################################

apt-get update -qq
#apt-get -qy upgrade

# install the compiler stack that will be removed
#apt-get install -qy make gcc tcl-dev libssl-dev
apt-get install -qy build-essential libtcl8.6 libtcl8.6-dbg tcl8.6-dev libssl-dev

# install the dependencies for eggdrop, namely TCL
apt-get install -qy tcl

blddir=`mktemp -d` && cd $blddir

# fetch eggdrop source
curl -o eggdrop1.6.21.tar.bz2 ftp://ftp.eggheads.org/pub/eggdrop/source/1.6/eggdrop1.6.21.tar.bz2
tar -xjf eggdrop1.6.21.tar.bz2
#curl -L -o eggdrop-develop.tar.gz ftp://ftp.eggheads.org/pub/eggdrop/source/snapshot/eggdrop-develop.tar.gz 
#tar -xf eggdrop-develop.tar.gz

# fetch additional module sources
cd eggdrop1.6.21
#cd eggdrop-develop

cd src/mod
curl -L -o dccidlekick.mod.1.0.1.tar.gz http://www.egghelp.org/files/modules/dccidlekick.mod.1.0.1.tar.gz
tar xf dccidlekick.mod.1.0.1.tar.gz
curl -L -o joinflood.mod.1.0.1.tar.gz http://www.egghelp.org/files/modules/joinflood.mod.1.0.1.tar.gz
tar xf joinflood.mod.1.0.1.tar.gz
curl -L -o kickflood.mod.1.0.1.tar.gz http://www.egghelp.org/files/modules/kickflood.mod.1.0.1.tar.gz
tar xf kickflood.mod.1.0.1.tar.gz
curl -L -o noclones.mod.1.0.1.tar.gz http://www.egghelp.org/files/modules/noclones.mod.1.0.1.tar.gz
tar xf noclones.mod.1.0.1.tar.gz
curl -L -o norepeat.mod.1.0.1.tar.gz http://www.egghelp.org/files/modules/norepeat.mod.1.0.1.tar.gz
tar xf norepeat.mod.1.0.1.tar.gz
cd ../..

# configure eggdrop for compilation
./configure --with-tclinc=/usr/include/tcl8.6/tcl.h --with-tcllib=/usr/lib/x86_64-linux-gnu/libtcl8.6.so
make config

# compile
make

# install
make install DEST=/opt/eggdrop

# need to deal with SSL?
# make sslcert DEST=/opt/eggdrop
cp ssl.conf /opt/eggdrop/ssl.default.conf

#
cd /tmp
rm -rf $blddir/eggdrop*

# remove compile-time only items
apt-get remove -y tcl-dev libssl-dev make gcc
apt-get autoremove -y
apt-get autoclean -y
apt-get clean -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


