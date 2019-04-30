#!/usr/bin/bash

check() {
    if ! dracut_module_included "systemd-initrd"; then
        derror "grub2-emu needs systemd-initrd in the initramfs"
        return 1
    fi

    return 0
}

depends() {
    echo "systemd-initrd"
    return 0
}

install() {
    local _dir
    inst_binary grub2-emu
    inst_hook pre-mount 01 "${moddir}/grub2-mount-boot.sh"

    for i in \
        grub2-emu.service \
        grub2-emu.target \
        ; do
        inst_simple "${moddir}/${i}" "${systemdsystemunitdir}/${i}"
    done

    ln_r "${systemdsystemunitdir}/grub2-emu.service" "${systemdsystemunitdir}/initrd-switch-root.service"

    mkdir -p "${initdir}${systemdsystemunitdir}/grub2-emu.target.wants"
    for i in \
        dracut-cmdline.service \
        dracut-initqueue.service \
        dracut-pre-mount.service \
        dracut-pre-trigger.service \
        dracut-pre-udev.service \
        ; do
        ln_r "${systemdsystemunitdir}/${i}" "${systemdsystemunitdir}/grub2-emu.target.wants/${i}"
    done

    ln_r "${systemdsystemunitdir}/grub2-emu.target" "${systemdsystemunitdir}/default.target"
}
