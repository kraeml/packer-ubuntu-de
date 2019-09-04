#!/bin/bash -eux
export DEBIAN_FRONTEND=noninteractive
# Install Ansible repository.
tee "/etc/apt/apt.conf.d/01proxy" > "/dev/null" <<EOF
Acquire::http { Proxy "http://michl-laptop:3142"; };
Acquire::https { Proxy "https://"; };
EOF
#tee "/etc/pip.conf" > "/dev/null" <<EOF
#[global]
#index-url=http://michl-laptop:3141/root/pypi/
#trusted-host=michl-laptop
#EOF
if ansible --version 2>/dev/null ; then
	apt-get -y update
else
	apt-get -y install software-properties-common
	apt-add-repository ppa:ansible/ansible
	# Install Ansible.
	apt-get -y update
	apt-get -y install ansible
fi
# apt-get -y --force yes full-upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
echo Going reboot
reboot
echo Reboot starts
