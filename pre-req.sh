#!/bin/bash
systemctl stop firewalld
systemctl disable firewalld

chkconfig iptables off
chkconfig ip6tables off
chkconfig ntpd on

echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled
sysctl -w net.ipv6.conf.all.disable_ipv6=1 
sysctl -w net.ipv6.conf.default.disable_ipv6=1
service tuned stop
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/SELINUX=permissive/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sed -i 's/SELINUX=permissive/SELINUX=disabled/' /etc/selinux/config
setenforce 0

sudo su -c 'cat >>/etc/sysctl.conf <<EOL
net.ipv6.conf.all.disable_ipv6 =1
net.ipv6.conf.default.disable_ipv6 =1
net.ipv6.conf.lo.disable_ipv6 =1
EOL'

sudo su -c 'cat >>/etc/rc.local <<EOL
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
echo never > /sys/kernel/mm/transparent_hugepage/defrag 
fi
exit 0
EOL'

sysctl vm.swappiness=1
sudo su -c 'cat >>/etc/sysctl.conf <<EOL
vm.swappiness=1
EOL'
reboot
