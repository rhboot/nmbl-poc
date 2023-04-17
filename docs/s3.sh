#!/bin/bash

mkdir /etc/dracut-grub2.conf.d/
rsync -avP --del 99grub2-emu/ /usr/lib/dracut/modules.d/99grub2-emu/
cp etc/dracut-grub2.conf.d/grub2-emu.conf /etc/dracut-grub2.conf.d/
cp etc/dracut.conf.d/grub2-emu.conf /etc/dracut.conf.d/
