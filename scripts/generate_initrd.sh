#!/bin/bash

pushd $1
#cp /home/javier/devel/grub2/grub-core/grub-emu ./sbin
#cp -a /usr/lib64/libSDL* ./usr/lib64/
find . | cpio -o -c | gzip -9 > ../$1.img
popd
