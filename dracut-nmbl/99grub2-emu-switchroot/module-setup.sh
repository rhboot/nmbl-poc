#!/usr/bin/bash

check() {
    return 0
}

depends() {
    return 0
}

install() {
    local _dir
    inst_binary grub2-emu
    inst_hook pre-mount 01 "${moddir}/grub2-mount-boot.sh"

    for i in \
        grub2-emu-switchroot.service \
        grub2-emu-switchroot.target \
        ; do
        inst_simple "${moddir}/${i}" "${systemdsystemunitdir}/${i}"
    done

    # Running here is too early, but we also need dracut-mount to not run
    ln_r "/dev/null" "${systemdsystemunitdir}/dracut-mount.service"

    mkdir -p "${initdir}${systemdsystemunitdir}/grub2-emu-switchroot.target.wants"
    for i in \
        dracut-cmdline.service \
        dracut-initqueue.service \
        dracut-pre-mount.service \
        dracut-pre-trigger.service \
        dracut-pre-udev.service \
        ; do
        ln_r "${systemdsystemunitdir}/${i}" "${systemdsystemunitdir}/grub2-emu-switchroot.target.wants/${i}"
    done
}
