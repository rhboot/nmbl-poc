# SPDX-License-Identifier: GPLv3
#
# utils.mk - make utilities
# Copyright Peter Jones <pjones@redhat.com>
#

VERSION = 0
RELEASE = 1

DESTDIR := temp
DATE=$(shell date "+%Y%m%d")
ESPDIR := /boot/efi/EFI/BOOT
KVRA := $(shell rpm -q kernel-core --qf '%{VERSION}-%{RELEASE}.%{ARCH}\n' | tail -n 1)
ARCH := $(shell rpm --eval '%{_build_arch}')
EFI_ARCH := $(shell rpm --eval '%{efi_arch}')
OS_NAME := $(shell grep '^ID=' /etc/os-release | sed 's/ID=//')
OS_VERSION := $(shell grep '^VERSION_ID=' /etc/os-release | sed 's/VERSION_ID=//')
OS_DIST := $(shell rpm --eval '%{dist}')
VR := $(VERSION)-$(RELEASE)$(OS_DIST)

ifeq ($(.DEFAULT_GOAL),)
.DEFAULT_GOAL := all
endif

RPMBUILD_ARGS := -D "_topdir $(TOPDIR)" \
		 -D '_builddir %{_topdir}' \
		 -D '_rpmdir %{_topdir}' \
		 -D '_sourcedir %{_topdir}' \
		 -D '_specdir %{_topdir}' \
		 -D '_srcrpmdir %{_topdir}' \
		 -D 'dist $(OS_DIST)'

.EXPORT_ALL_VARIABLES:

% : %.in
	@sed \
		-e 's,@@VERSION@@,$(VERSION),g' \
		-e 's,@@RELEASE@@,$(RELEASE),g' \
		$< > $@

# vim:ft=make
