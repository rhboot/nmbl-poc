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

mkdir /root/.ssh
cat > /root/.ssh/authorized_keys << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfnyzwBs4BA6ePsikGibk+5K3ziPRQrI7JM0m9Sg+pl3nyY5lSKJRo8sMQe+ofzh+tVb+KsEsR5+zWW3Q++8qFs1M5k35bnoPiMhLfjPZDo8pvaOxKu6rGmAmC0YqvVmMth3AcwbLQMTfbrYpwwzg5rQrx1+c6Bt7BYZPA+DDYE5xhwVEQUgBor4W+sNDupAV2CC8VfraoxZ40Ci9JUWDZCI56+8wYCDV6EIQ2mAsMnobWnwAxhd4c41ExCyB2MIeoSUjjecEqRmELlS64ajgvTrBvXaA1Faast0JyCs80uLksT3gCjwhHrKckt2tu7TPzYl0fdnqbHJqBKs8fxcAxCxLVu0Lu7hytedNhDu2mwxVAAlG4dlZHw4VgiRuAXW6CFtHvx347jySF+sz4rWaZVQltPHbPbaORPZMNz6oMuq6aAb5YUtZcv7XdfKV1U1AiMVFn1xfObvjdMXDzmYJpMHXndOGbKz6d4bvyOmMe8YQ857jYKIzU1q15YZ/NxzE= root@hpe-dl360gen10-01.hpe2.lab.eng.bos.redhat.com
EOF

cat > /etc/yum.repos.d/kernel.repo << EOF
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

