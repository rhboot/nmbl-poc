# SPDX-License-Identifier: GPLv3
#
# Makefile
# Copyright Peter Jones <pjones@redhat.com>
#

TOPDIR ?= $(realpath ./)
include $(TOPDIR)/utils.mk

MOCK_ROOT_NAME ?= $(OS_NAME)-$(OS_VERSION)-$(ARCH)
MOCK_ROOT_PATH ?= $(abspath $(shell mock -r "$(MOCK_ROOT_NAME)" --print-root-path)/../)
DEPLOY_HOST ?= nmbl

all: 

dracut-nmbl-$(VERSION).tar.xz :
	$(MAKE) -C dracut-nmbl tarball
	mv -v dracut-nmbl/dracut-nmbl-$(VERSION).tar.xz .

dracut-nmbl-$(VR).src.rpm : dracut-nmbl.spec dracut-nmbl-$(VERSION).tar.xz
	rpmbuild $(RPMBUILD_ARGS) -bs $<

dracut-nmbl-$(VR).noarch.rpm : dracut-nmbl-$(VR).src.rpm
	mock -r "$(MOCK_ROOT_NAME)" --rebuild dracut-nmbl-$(VR).src.rpm
	mv "$(MOCK_ROOT_PATH)/result/$@" .

nmbl-builder-$(VERSION).tar.xz :
	$(MAKE) -C nmbl-builder tarball
	mv -v nmbl-builder/nmbl-builder-$(VERSION).tar.xz .

nmbl-builder-$(VR).src.rpm : nmbl-builder.spec nmbl-builder-$(VERSION).tar.xz
	rpmbuild $(RPMBUILD_ARGS) -bs $<

nmbl-$(KVRA).rpm: nmbl-builder-$(VR).src.rpm dracut-nmbl-$(VR).noarch.rpm
	mock -r "$(MOCK_ROOT_NAME)" --install dracut-nmbl-$(VR).noarch.rpm --cache-alterations --no-cleanup-after
	mock -r "$(MOCK_ROOT_NAME)" --installdeps nmbl-builder-$(VR).src.rpm --cache-alterations --no-clean --no-cleanup-after
	mock -r "$(MOCK_ROOT_NAME)" --rebuild nmbl-builder-$(VR).src.rpm --no-clean
	mv -v "$(MOCK_ROOT_PATH)/result/$@" .

deploy: nmbl-$(KVRA).rpm
	scp $< "root@$(DEPLOY_HOST):"
	ssh "root@$(DEPLOY_HOST)" ./deploy.sh "$<"

init-mock:
	mock -r "$(MOCK_ROOT_NAME)" --init

clean-mock:
	mock -r "$(MOCK_ROOT_NAME)" --clean

clean:
	rm -vf $(wildcard *.tar *.tar.xz *.rpm *.spec) 

.PHONY: all clean clean-mock init-mock deploy

# vim:ft=make
