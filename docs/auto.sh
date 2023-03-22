#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "usage: ./auto.sh $virt_name"
    exit
fi

VIRTNAME=$1

VIRT_IP=$(virsh domifaddr --domain $VIRTNAME | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')

scp -r s*sh ../etc/ ../99grub2-emu/ root@$VIRT_IP:.
