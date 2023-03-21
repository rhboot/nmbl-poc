# SPDX-License-Identifier: GPLv3
#
# Makefile
# Copyright Peter Jones <pjones@redhat.com>
#

DESTDIR ?= temp
DATE=$(shell date "+%Y%m%d")
ESPDIR ?= /boot/efi/EFI/BOOT
VERSION = 0
RELEASE = 1
OS_NAME ?= $(shell grep '^ID=' /etc/os-release | sed 's/ID=//')
OS_VERSION ?= $(shell grep '^VERSION_ID=' /etc/os-release | sed 's/VERSION_ID=//')
OS_DIST ?= $(shell rpm --eval '%{dist}')
SRPM = nmbl-$(VERSION)-$(RELEASE)$(OS_DIST).src.rpm
TARBALL = nmbl-$(VERSION).tar.xz
KVERREL ?= $(shell rpm -q kernel-core --qf '%{VERSION}-%{RELEASE}.%{ARCH}\n' | tail -n 1)
ARCH ?= $(shell rpm --eval '%{_build_arch}')
RPM = nmbl-$(VERSION)-$(RELEASE)$(OS_DIST).$(ARCH).rpm
MOCKROOT ?= $(OS_NAME)-$(OS_VERSION)-$(ARCH)

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

nmbl.spec : nmbl.spec.in
	@sed \
		-e 's,@@VERSION@@,$(VERSION),g' \
		-e 's,@@RELEASE@@,$(RELEASE),g' \
		$< > $@

nmbl.initramfs.img:
	dracut --verbose --confdir /etc/dracut-grub2.conf.d/ --no-hostonly \
		nmbl.initramfs.img \
		$(KVERREL)

nmbl.uki: nmbl.initramfs.img
	/usr/lib/systemd/ukify -o nmbl.uki \
		--os-release @/etc/os-release \
		--uname $(KVERREL) \
		--efi-arch x64 \
		--stub /usr/lib/systemd/boot/efi/linuxx64.efi.stub \
		/boot/vmlinuz-$(KVERREL) \
		"nmbl.initramfs.img"

nmbl-$(VERSION).tar.xz :
	@git archive --format=tar --prefix=nmbl-$(VERSION)/ HEAD | xz > $@

$(SRPM) : nmbl.spec $(TARBALL)
	@rpmbuild -D "_topdir %(echo $$(pwd))" \
		  -D '_builddir %{_topdir}' \
		  -D '_rpmdir %{_topdir}' \
		  -D '_sourcedir %{_topdir}' \
		  -D '_specdir %{_topdir}' \
		  -D '_srcrpmdir %{_topdir}' \
		  -bs $<

install: nmbl.uki
	@install -m 0755 -d "$(DESTDIR)$(ESPDIR)"
	install -m 0644 -t "$(DESTDIR)$(ESPDIR)" nmbl.uki

tarball : $(TARBALL)

srpm : $(SRPM)

init-mock:
	@mock -r "$(MOCKROOT)" --init

$(RPM) : $(SRPM)
	@mock -r "$(MOCKROOT)" --installdeps --no-clean $(SRPM)
	# well, here's a hot mess... this needs to be an rpm we can buildreq on, eventually.
	find etc/ -exec mock -r "$(MOCKROOT)" --copyin --no-clean {} /{} \;
	find 99grub2-emu -exec mock -r "$(MOCKROOT)" --copyin --no-clean {} /usr/lib/dracut/modules.d/{} \;
	mock -r "$(MOCKROOT)" --rebuild --no-clean $(SRPM)
	cp -av "/var/lib/mock/$(MOCKROOT)/result"/* ./

rpm : $(RPM)

clean-mock:
	@mock -r "$(MOCKROOT)" --clean

clean:
	@rm -vf nmbl.initramfs.img nmbl.uki nmbl.spec \
		build.log hw_info.log installed_pkgs.log root.log state.log \
		$(wildcard nmbl*.tar nmbl*.tar.xz nmbl*.rpm) 

.PHONY: all clean clean-mock init-mock install install-grub2-emu rpm srpm \
	tarball

# vim:ft=make
