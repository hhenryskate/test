#!/bin/bash
sed -i -e 's/command//g' /root/.ssh/authorized_keys
sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i -e 's/PasswordAuthentication no/PasswordAuthentication Yes/g' /etc/ssh/sshd_config
systemctl reload sshd
echo "ubuntu ALL=NOPASSWD: ALL" >> /etc/sudoers
reboot
