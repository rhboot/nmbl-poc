#!/bin/bash
#

echo -n "\nmbl.uki quiet console=ttyS0 boot=$(awk '/ \/boot / {print $1}' /etc/fstab) rd.systemd.gpt_auto=0" | iconv -f UTF8 -t UCS-2LE | efibootmgr -b 0010 -C -d /dev/vda -p 1 -L nmbl -l /EFI/fedora/shimx64.efi -@ - -n 0010

echo -n "\nmbl-cloud.uki console=ttyS0 boot=$(awk '/ \/boot / {print $1}' /etc/fstab) root=$(awk '/ \/ / {print $1}' /etc/fstab) rd.system.gpt_auto=0" | iconv -f UTF8 -t UCS-2LE | efibootmgr -b 0011 -C -d /dev/vda -p 1 -L nmbl-cloud -l /EFI/fedora/shimx64.efi -@ - -n 0011

echo -n "\nmbl-ws.uki quiet console=ttyS0 boot=$(awk '/ \/boot / {print $1}' /etc/fstab) rd.systemd.gpt_auto=0" | iconv -f UTF8 -t UCS-2LE | efibootmgr -b 0012 -C -d /dev/vda -p 1 -L nmbl-ws -l /EFI/fedora/shimx64.efi -@ - -n 0012
