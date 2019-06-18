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

initctl list
echo
initctl stop docker

# create new fs
mv "$dir" "$old"
mkdir "$dir"
mount -t tmpfs tmpfs "$dir"
chown --reference="$old" "$dir"
chmod --reference="$old" "$dir"

# copy
(cd  "$old"; tar cf - .) | (cd "$dir"; tar xf - )

# 
initctl start docker

docker ps -a



## EOF ##
