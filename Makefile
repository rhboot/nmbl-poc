# SPDX-License-Identifier: GPLv3
#
# Makefile
# Copyright Peter Jones <pjones@redhat.com>
#

DESTDIR ?= temp
DATE=$(shell date "+%Y%m%d")
.ONESHELL:

all:

install-grub2-emu:
	install -m 0755 -d "$(DESTDIR)/usr/lib/dracut/modules.d/99grub2-emu"
	install -m 0755 -t "$(DESTDIR)/usr/lib/dracut/modules.d/99grub2-emu" $(wildcard 99grub2-emu/*)
	install -m 0755 -d "$(DESTDIR)/etc/dracut-grub2.conf.d"
	install -m 0644 -t "$(DESTDIR)/etc/dracut-grub2.conf.d" etc/dracut-grub2.conf.d/grub2-emu.conf
	install -m 0755 -d "$(DESTDIR)/etc/dracut.conf.d"
	install -m 0755 -t "$(DESTDIR)/etc/dracut.conf.d" etc/dracut.conf.d/grub2-emu.conf
	install -m 0755 -d "$(DESTDIR)/etc/grub.d"
	install -m 0755 -t "$(DESTDIR)/etc/grub.d" etc/grub.d/10_linux

nmbl.uki:
	podman build -f initrd.container --tag localhost/nmbl.initrd:$(DATE) .
	CTR=$$(podman container run --detach --init localhost/nmbl.initrd:$(DATE) /root/idle)
	podman cp $${CTR}:/nmbl.initramfs.img .
	podman cp $${CTR}:/nmbl.uki .
	podman container stop $${CTR}

uki-builder-shell:
	podman run -i -t -a STDIN,STDOUT,STDERR localhost/nmbl.initrd:$(DATE) /bin/bash -l -i


# vim:ft=make
