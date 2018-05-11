builds/virtualbox-ubuntu1804.box: virtualbox-ovf/box.ovf
	source ../ENV_VARS
	./bin/packer build -force packer-ubuntu-de.json

virtualbox-ovf/box.ovf:
	ansible-playbook check_box.yml

clean:
	rm virtualbox-ovf/*
	rm builds/virtualbox-ubuntu1804.box

all: builds/virtualbox-ubuntu1804.box
