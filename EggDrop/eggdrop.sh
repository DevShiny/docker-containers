#!/bin/bash
umask 000

[[ ! -f /config/eggdrop.conf ]] && cp /opt/eggdrop/eggdrop.default.conf /config/eggdrop.conf

chown -R nobody:users /opt/eggdrop /config /logs
chmod u+x /config/eggdrop.conf

cd /opt/eggdrop

if [ ! -f /config/eggdrop.user ]
then
	exec /sbin/setuser nobody /opt/eggdrop/eggdrop -n -m /config/eggdrop.conf
else
	exec /sbin/setuser nobody /opt/eggdrop/eggdrop -n /config/eggdrop.conf
fi
