#!/bin/bash

dnf install -y pesign mokutil keyutils rsync git emacs-nox dracut-network grub2-emu binutils systemd-ukify systemd-boot-unsigned systemd-networkd kexec-tools btrfs-progs lvm2

efikeygen -d /etc/pki/pesign -S -k -c 'CN=Sids Key' -n 'Sids Secureboot'
certutil -d /etc/pki/pesign -n 'Sids Secureboot' -Lr > sb_cert.cer
mokutil --import sb_cert.cer

