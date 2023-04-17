#!/bin/bash

if [[ $# != 1 ]]; then
    echo 'usage: ./test.sh virt_name'
    exit
fi

virtname=${1}
vm_dir=$(pwd)/../vm_common

. ${vm_dir}/setup.sh

virt-install --os-variant fedora-unknown --name $virtname --memory 4096 --boot loader=/usr/share/edk2/ovmf/OVMF_CODE.secboot.fd,loader_ro=yes,loader_type=pflash,nvram_template=${vm_dir}/nmbl_VARS.fd,loader_secure=yes --features smm.state=on --vcpus 2 --disk size=20 --noautoconsole --graphics none --serial file,path=${tmp_dir}/console_output.log 2> $tmp_dir/qemu_err_output.log --initrd-inject=${vm_dir}/install_fedora.ks --tpm model=tpm-crb,backend.type=emulator,backend.version=2.0 --extra-args 'console=ttyS0 inst.ks=file:/install_fedora.ks' --location=http://download.eng.bos.redhat.com/released/fedora/F-38/Beta/1.3/Server/x86_64/os/

if [[ -s $tmp_dir/qemu_err_output.log ]]; then
    echo -e '\nthere was some problem with the installation.\nplease check' $tmp_dir/qemu_err_output.log
    exit
fi

echo -e '\nplease wait for the installation to finish.'
echo 'console output in being redirected to:' $tmp_dir/console_output.log

while :
do
    sleep 30
    if [[ $(grep Rebooting $tmp_dir/console_output.log) ]]; then
        sleep 5
        echo 'installation successfully completed.'
        break
    fi
done

echo -e '\nwill attempt to start' $virtname
virsh start $virtname
sleep 30

virt_ip=$(virsh domifaddr --domain $virtname | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')

cp -f ${vm_dir}/config /root/.ssh/
sed -i "s/IPADDR/${virt_ip}/" /root/.ssh/config

echo -e '\ninstalling necessary packages...\n'
ssh -i ${vm_dir}/id_rsa_test root@$virt_ip 'dnf install -y pesign mokutil keyutils rsync git emacs-nox dracut-network grub2-emu binutils systemd-ukify systemd-boot-unsigned systemd-networkd kexec-tools btrfs-progs lvm2'

echo -e '\n\nadding boot counting...\n'
scp -i ${vm_dir}/id_rsa_test ${vm_dir}/boot-count.service root@$virt_ip:/etc/systemd/system/.
scp -i ${vm_dir}/id_rsa_test ${vm_dir}/boot_count.sh root@$virt_ip:/usr/sbin/.
ssh -i ${vm_dir}/id_rsa_test root@$virt_ip 'systemctl daemon-reload'
ssh -i ${vm_dir}/id_rsa_test root@$virt_ip 'systemctl enable boot-count.service'

echo -e '\n\ninstalling new kernel...\n'
ssh -i ${vm_dir}/id_rsa_test root@$virt_ip 'dnf install -y kernel-6.3.0'

scp -r -i ${vm_dir}/id_rsa_test etc/ 99grub2-emu/ sign_kernel.sh make_nmbl.sh root@$virt_ip:.
scp -i ${vm_dir}/id_rsa_test ${vm_dir}/key_db/* root@$virt_ip:/etc/pki/pesign/.

ssh -i ${vm_dir}/id_rsa_test root@$virt_ip 'source sign_kernel.sh'
sleep 60
ssh -i ${vm_dir}/id_rsa_test root@$virt_ip 'source make_nmbl.sh'

sleep 10

echo -e '\nshutting down machine.'
virsh shutdown $virtname
sleep 15

echo -e '\n\nto boot using nmbl run: virsh start' $virtname
echo 'serial console output is here:' $tmp_dir/console_output.log
echo "you can connect using: ssh -i id_rsa_test root@$virt_ip"
