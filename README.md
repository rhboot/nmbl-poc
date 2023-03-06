# nmbl proof of concept

This is intended as a proof of concept for nmbl.

# what's here so far

| file | description |
|--|--|
| `99grub2-emu` | grub2-emu plugin for dracut |
| `99grub2-emu/grub2-emu.service` | systemd service to run our grub menu |
| `99grub2-emu/grub2-emu.target` | systemd target to run our services |
| `99grub2-emu/grub2-mount-boot.sh` | helper to mount /boot inside the running initramfs |
| `99grub2-emu/module-setup.sh` | dracut module setup program |
| `etc/dracut-grub2.conf.d/grub2-emu.conf` | dracut configuration to use this plugin |
| `etc/dracut.conf.d/grub2-emu.conf` | default dracut configuration to ignore this plugin |
| `etc/grub.d/10_linux` | grub2-install plugin to build our grub.cfg |
| `scripts/extract_initrd.sh` | simple (too simple) script to unpack an initramfs |
| `scripts/generate_initrd.sh` | simple script to generate an initramfs |
| `kernel patches/sig-bound-v2` | kernel patch series to fix signature size rules |
