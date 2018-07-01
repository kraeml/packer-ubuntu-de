#!/bin/bash -eux

# Install Ansible repository.
tee "/etc/apt/apt.conf.d/01proxy" > "/dev/null" <<EOF
Acquire::http { Proxy "http://michl-laptop.fritz.box:3142"; };
Acquire::https { Proxy "https://"; };
EOF
if ansible --version ; then
	apt-get -y update
else
	apt-get -y update && apt-get -y upgrade
	apt-get -y install software-properties-common
	apt-add-repository ppa:ansible/ansible
	# Install Ansible.
	apt-get -y update
	apt-get -y install ansible
fi
apt-get -y full-upgrade
echo Going reboot
reboot
echo Reboot starts
