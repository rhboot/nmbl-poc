#!/bin/bash
#
pesign -s -c 'Sids Secureboot' -i /boot/efi/EFI/fedora/nmbl-cloud.uki -o /boot/efi/EFI/fedora/nmbl-cloud.uki.signed
pesign -r --signature-number 0 -i /boot/efi/EFI/fedora/nmbl-cloud.uki.signed -o /boot/efi/EFI/fedora/nmbl-cloud.uki --force

pesign -s -c 'Sids Secureboot' -i /boot/efi/EFI/fedora/nmbl-megalith.uki -o /boot/efi/EFI/fedora/nmbl-megalith.uki.signed
pesign -r --signature-number 0 -i /boot/efi/EFI/fedora/nmbl-megalith.uki.signed -o /boot/efi/EFI/fedora/nmbl.uki

pesign -s -c 'Sids Secureboot' -i /boot/efi/EFI/fedora/nmbl-workstation.uki -o /boot/efi/EFI/fedora/nmbl-workstation.uki.signed
pesign -r --signature-number 0 -i /boot/efi/EFI/fedora/nmbl-workstation.uki.signed -o /boot/efi/EFI/fedora/nmbl-ws.uki

