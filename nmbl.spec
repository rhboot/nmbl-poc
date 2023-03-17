%global debug_package %{nil}

Summary: nmbl proof of concept as a package
Name: nmbl
Version: 0
Release: 0%{?dist}
Group: System Environment/Base
License: GPLv3
URL: https://github.com/rhboot/nmbl-poc

BuildRequires: efi-srpm-macros
BuildRequires: podman

# XXX this is a lie until we realize some truth
Source0: https://github.com/rhboot/nmbl-poc/nmbl-%{version}.tar.xz

%description
nmbl-poc is a proof of concept for a bootloader for UEFI machines based on
the linux kernel and grub-emu, using either switchroot or kexec.

%prep
%autosetup -S git_am

%build
make nmbl.uki

%install
%make_install ESPDIR="%{efi_esp_dir}"

%files
%defattr(-,root,root,-)
%{efi_esp_dir}/nmbl.uki

%changelog
* Fri Mar 17 2023 Peter Jones <pjones@redhat.com> - 0-0
- Yeet a spec file into the world
