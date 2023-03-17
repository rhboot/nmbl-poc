# SPDX-License-Identifier: GPLv3
#
# Makefile
# Copyright Peter Jones <pjones@redhat.com>
#

DESTDIR ?= temp
DATE=$(shell date "+%Y%m%d")
ESPDIR ?= /boot/efi/EFI/BOOT
VERSION = 0
.ONESHELL:

all: nmbl.uki

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
	set -eu
	set -o pipefail
	podman build -f initrd.container --tag localhost/nmbl.initrd:$(DATE) .
	CTR=$$(podman container run --detach --init localhost/nmbl.initrd:$(DATE) /root/idle)
	podman cp $${CTR}:/nmbl.initramfs.img .
	podman cp $${CTR}:/nmbl.uki .
	podman container stop $${CTR}

uki-builder-shell:
	podman run -i -t -a STDIN,STDOUT,STDERR localhost/nmbl.initrd:$(DATE) /bin/bash -l -i

nmbl-$(VERSION).tar.xz : nmbl-$(VERSION).tar
	@xz $^

nmbl-$(VERSION).tar :
	@git archive --format=tar --prefix=nmbl-$(VERSION)/ HEAD > $@

tarball : nmbl-$(VERSION).tar.xz

install: nmbl.uki
	install -m 0755 -d "$(DESTDIR)$(ESPDIR)"
	install -m 0644 -t "$(DESTDIR)$(ESPDIR)" nmbl.uki

rpm: tarball nmbl.spec
	@mkdir temp
	ln nmbl-$(VERSION).tar.xz temp/
	rpmbuild -D "_topdir %(echo $$(pwd)/temp/)" \
		  -D '_builddir %{_topdir}' \
		  -D '_rpmdir %{_topdir}' \
		  -D '_sourcedir %{_topdir}' \
		  -D '_specdir %{_topdir}' \
		  -D '_srcrpmdir %{_topdir}' \
		  -ba nmbl.spec

clean:
	@rm -vf nmbl.initramfs.img nmbl.uki $(wildcard nmbl*.tar nmbl*.tar.xz)

.PHONY: rpm clean install tarball uki-builder-shell install-grub2-emu

# vim:ft=make
