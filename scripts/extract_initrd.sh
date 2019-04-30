#!/bin/bash

[ -z $1 ] && exit 1

dir="$(echo $1 | sed 's/\.img//')"
mkdir $dir && pushd $dir
/usr/lib/dracut/skipcpio ../$1 | gunzip | cpio -idmv
popd
