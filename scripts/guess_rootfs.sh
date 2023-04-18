#!/bin/sh

check_lvm () {
    lsblk -f | grep "LVM" > /dev/null 2>&1
}

set_lvm () {
    root=$(mount | grep " / " | awk '{print $1}')
    rd_lvm_lv=$(grep -oP '(?<=rd.lvm.lv=)[^ ]*' /proc/cmdline)
    echo "root=$root ro rd.lvm.lv=$rd_lvm_lv"
    exit
}

check_btrfs () {
    fs=$(lsblk -f | grep "$(awk '/ \/ / {print $1}' /etc/fstab | grep -oP '(?<=UUID=)[^ ]*')" | awk '{print $2}')
    if [ "$fs" = "btrfs" ]
    then
	    set_btrfs
    fi
}

set_btrfs () {
    root=$(grep -oP '(?<=root=)[^ ]*' /proc/cmdline)
    rootflags=$(grep -oP '(?<=rootflags=)[^ ]*' /proc/cmdline)
    echo "root=$root ro rootflags=$rootflags"
    exit
}

set_standard () {
    root=$(grep -oP '(?<=root=)[^ ]*' /proc/cmdline)
    echo "root=$root ro"
    exit
}

if check_lvm
then
    set_lvm
fi

check_btrfs

set_standard
