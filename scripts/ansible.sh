#!/bin/bash -eux

# Install Ansible repository.
if ansible --version ; then
	apt -y update
else
	apt -y update && apt-get -y upgrade
	apt -y install software-properties-common
	apt-add-repository ppa:ansible/ansible
	# Install Ansible.
	apt -y update
	apt -y install ansible
fi
apt -y full-upgrade
echo Going reboot
reboot
echo Reboot starts
