#!/bin/bash
#
# File:         relibdo.sh
# Created:      180619
# Description:
#


## ENV ##

dir="/var/lib/docker"
old="/var/lib/docker-old"

## MAIN ##

systemctl | grep -i docker
systemctl stop docker

# create new fs
mv "$dir" "$old"
mkdir "$dir"
mount -t tmpfs tmpfs "$dir"
chown --reference="$old" "$dir"
chmod --reference="$old" "$dir"

# copy
(cd  "$old"; tar cf - .) | (cd "$dir"; tar xf - )

# 
systemctl start docker

docker ps -a



## EOF ##
