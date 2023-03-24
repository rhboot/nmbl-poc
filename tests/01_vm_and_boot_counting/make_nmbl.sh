#!/bin/bash

echo -e '\n\nsetting up config files...'

mkdir /etc/dracut-grub2.conf.d/
rsync -avP --del 99grub2-emu/ /usr/lib/dracut/modules.d/99grub2-emu/
cp etc/dracut-grub2.conf.d/grub2-emu.conf /etc/dracut-grub2.conf.d/
cp etc/dracut.conf.d/grub2-emu.conf /etc/dracut.conf.d/
mv /etc/grub.d/10_linux{,.bak}
cp etc/grub.d/10_linux /etc/grub.d/

kernel=$(uname -r)

echo -e '\n\ncreating new nmbl bootloader...'

dracut --verbose --confdir /etc/dracut-grub2.conf.d/ --no-hostonly ./nmbl.uki $kernel --uefi --kernel-cmdline "debug=all console=ttyS0 boot=$(awk '/ \/boot / {print $1}' /etc/fstab) rd.systemd.gpt_auto=0" --xz
pesign -s -c 'Sids Secureboot' -i nmbl.uki -o nmbl.uki.signed

mv /boot/efi/EFI/fedora/grubx64.efi{,.bak}
cp nmbl.uki.signed /boot/efi/EFI/fedora/grubx64.efi
