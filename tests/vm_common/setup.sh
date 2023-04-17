#!/bin/bash

dnf install -y libvirt qemu-kvm virt-install policycoreutils-python-utils

systemctl start libvirtd

tmp_dir=$(mktemp -d)
chmod +rx $tmp_dir
# Use appropriate SELinux context for the log files
semanage fcontext -a -t virt_log_t "$tmp_dir(/.*)?"
restorecon $tmp_dir

chmod 600 ${vm_dir}/id_rsa_test
