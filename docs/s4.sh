#!/bin/bash

dracut --verbose --confdir /etc/dracut-grub2.conf.d/ --no-hostonly ./nmbl.uki 6.3.0-0.rc2.89f5349e0673.24.test.fc38.x86_64 --uefi --kernel-cmdline "debug=all console=ttyS0 boot=$(awk '/ \/boot / {print $1}' /etc/fstab) rd.systemd.gpt_auto=0" --xz
pesign -s -c 'Sids Secureboot' -i nmbl.uki -o nmbl.uki.signed

mv /boot/efi/EFI/fedora/grubx64.efi{,.bak}
cp nmbl.uki.signed /boot/efi/EFI/fedora/grubx64.efi
