#!/bin/bash -eux

# Install Ansible repository.
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
