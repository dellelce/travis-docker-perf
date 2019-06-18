#!/bin/bash
#
# File:         relibdo.sh
# Created:      180619
# Description:

## FUNCTIONS

relibdocker()
{
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
}

## ENV ##

dir="/var/lib/docker"
old="/var/lib/docker-old"
mkit_url="https://github.com/dellelce/mkit/archive/0.0.37.tar.gz"

## MAIN ##

wget -O mkit.tar.gz -q "$mkit_url" || exit $?
tar xzf mkit.tar.gz
cd $(dirname $(find . -name mkit.sh))

# build opengl with default configuration

start=$(date +%s)
PROFILE="opengl" DOCKER_IMAGE="dellelce/opengl-base" PREFIX="/app/opengl" \
 ./mkit-wrapper.sh yes || exit $?
end=$(date +%s)

let elapsed_default="(( $end - $start ))"

echo
echo "Elapsed in default conguration: ${elapsed_default}"
echo

#####

relibdocker || exit $?

#####

echo; echo
docker ps -a
docker images

#####

start=$(date +%s)
PROFILE="opengl" DOCKER_IMAGE="dellelce/opengl-base" PREFIX="/app/opengl" \
 ./mkit-wrapper.sh yes || exit $?
end=$(date +%s)

let elapsed_tmpfs="(( $end - $start ))"

echo
echo "Elapsed in tmpfs conguration: ${elapsed_tmpfs}"
echo

#####

echo; echo
docker ps -a
docker images

## EOF ##
