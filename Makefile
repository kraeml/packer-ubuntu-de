export VAGRANT_VAGRANTFILE = builds-config/Vagrantfile-$(BASE)

ifndef BASE
BASE = ubuntu_1804_de
endif

ifndef NO_CLOUD
FILE_NAME = packer-ubuntu_1804_de
else
FILE_NAME = packer-ubuntu_1804_de-no-cloud
endif

ifndef CONTROLS
CONTROLS = de
endif

no-cloud:
	cat packer-ubuntu_1804_de.json | jq 'del(."post-processors"[1])' > packer-ubuntu_1804_de-no-cloud.json

test_inspec:
	vagrant up
	echo $(CONTROLS)
	LC_MESSAGES=C /opt/inspec/bin/inspec exec \
		--controls=$(CONTROLS) \
		-t ssh://vagrant@$$(vagrant ssh-config \
			| grep HostName \
			| cut -d 'e' -f 2 \
			| cut -d ' ' -f 2):$$(vagrant ssh-config \
			| grep Port \
			| cut -d 't' -f 2 \
			| cut -d ' ' -f 2) \
		-i $$(vagrant ssh-config \
			| grep IdentityFile \
			| cut -d ' ' -f 4) \
		--password vagrant inspec_test/locale_de/

test_devsec:
	vagrant up
	LC_MESSAGES=C /opt/inspec/bin/inspec exec \
		-t ssh://vagrant@$$(vagrant ssh-config \
			| grep HostName \
			| cut -d 'e' -f 2 \
			| cut -d ' ' -f 2)\
			:$$(vagrant ssh-config \
			| grep Port \
			| cut -d 't' -f 2 \
			| cut -d ' ' -f 2) \
		-i $$(vagrant ssh-config \
			| grep IdentityFile \
			| cut -d ' ' -f 4) \
		--password vagrant https://github.com/dev-sec/linux-baseline

test: vagrant_box_clean test_inspec
	vagrant destroy --force 2>/dev/null || true

vagrant_box_clean:
	vagrant destroy --force 2>/dev/null || true
	vagrant box remove --force file://builds/$(BASE)/virtualbox-$(BASE).box 2>/dev/null || true

electronic:
	ansible-playbook --skip-tags dependencies --extra-vars BASE_NAME=de_electronic_jupyter build.yml
