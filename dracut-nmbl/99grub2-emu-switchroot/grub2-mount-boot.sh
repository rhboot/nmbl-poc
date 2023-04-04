#!/usr/bin/bash

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

boot=$(getarg boot=)
case "$boot" in
    LABEL=*)
        boot="$(echo $boot | sed 's,/,\\x2f,g')"
        boot="block:/dev/disk/by-label/${boot#LABEL=}"
        ;;
    UUID=*)
        boot="/dev/disk/by-uuid/${boot#UUID=}"
        ;;
    PARTUUID=*)
        boot="/dev/disk/by-partuuid/${boot#PARTUUID=}"
        ;;
    PARTLABEL=*)
        boot="/dev/disk/by-partlabel/${boot#PARTLABEL=}"
        ;;
    /dev/*)
        ;;
    *)
        die "You have to specify boot=<boot device> as a boot option for grub2-emu"
        ;;
esac

if ! [ -e "$boot" ]; then
    udevadm trigger --action=add >/dev/null 2>&1
    [ -z "$UDEVVERSION" ] && UDEVVERSION=$(udevadm --version)
    i=0
    while ! [ -e $boot ]; do
        if [ $UDEVVERSION -ge 143 ]; then
            udevadm settle --exit-if-exists=$boot
        else
            udevadm settle --timeout=30
        fi
        [ -e $boot ] && break
        sleep 0.5
        i=$(($i+1))
        [ $i -gt 40 ] && break
    done
fi

[ -e "$boot" ] || return 1

# This doesn't handle /boot being the same fs as /
[ -d "/boot" ] || mkdir -p -m 0755 "/boot"
info "Mounting $boot as /boot"
mount "$boot" /boot || return 1

exit 0
