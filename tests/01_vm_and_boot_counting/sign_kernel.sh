#!/bin/bash

kernel=$(grubby --default-kernel)

pesign -s -c 'Sids Secureboot' -i $kernel -o $kernel.signed

pesign -r --signature-number 0 -i $kernel.signed -o $kernel.2sig
pesign -r --signature-number 0 -i $kernel.2sig -o $kernel.signed --force

mv $kernel{,.bak}
cp $kernel.signed $kernel

echo -e '\n\nkernel is signed with:\n'
pesign -S -i $kernel

echo -e '\nrebooting into new kernel...\n'
sleep 2
reboot
