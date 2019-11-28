#!/bin/bash -eux
export DEBIAN_FRONTEND=noninteractive
get_ansible() {
        if ansible --version 2>/dev/null ; then
                sudo apt-get -y update
        else
                sudo apt-get -y install software-properties-common
                sudo apt-add-repository -y ppa:ansible/ansible
                # Install Ansible.
                sudo apt-get -y update
                sudo apt-get -y install ansible
        fi
}

