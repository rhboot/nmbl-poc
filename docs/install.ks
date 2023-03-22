text
timezone Europe/Prague --utc
keyboard --vckeymap=us --xlayouts='us'
lang en_US.UTF-8
rootpw fedora1357
zerombr
clearpart --all --initlabel
reqpart
part /boot --size 1024
part swap --fstype swap --recommended --label SWAP
part / --size 2048 --grow

reboot

%post
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

cat > /etc/yum.repos.d/test.repo << EOF
[kernel]
name=rh_kernel
baseurl=http://file.emea.redhat.com/mlewando/nmbl_kernel/
enabled=1
gpgcheck=0

[grub-89]
name=grub-89
baseurl=http://file.emea.redhat.com/mlewando/grub2-2.06-89.fc38.x86_64/
enabled=1
gpgcheck=0
EOF
%end
