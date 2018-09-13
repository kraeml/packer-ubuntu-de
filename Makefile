file=../ENV_VARS
token=`cat $(file)`
export ATLAS_TOKEN = $(token)
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

build: virtualbox-ovf/$(BASE)/box.ovf no-cloud
	packer build -force -var "box_name=$(BASE)" $(FILE_NAME).json

virtualbox-ovf/$(BASE)/box.ovf:
	ansible-playbook --extra-vars="BASE=$(BASE)" check_box.yml

clean_all: rm_box rm_no_cloud
	# Now Symlink
	# ToDo remove
	# rm virtualbox-ovf/$(BASE)/* 2>/dev/null || true

rm_box:
	rm builds/$(BASE)/virtualbox.box 2>/dev/null || true

rm_no_cloud:
	rm packer-ubuntu_1804_de-no-cloud.json 2>/dev/null || true

test_inspec:
	vagrant up
	echo $(CONTROLS)
	LC_MESSAGES=C inspec exec --controls=$(CONTROLS) -t ssh://vagrant@$$(vagrant ssh-config | grep HostName | cut -d 'e' -f 2 | cut -d ' ' -f 2):$$(vagrant ssh-config | grep Port | cut -d 't' -f 2 | cut -d ' ' -f 2) -i $$(vagrant ssh-config | grep IdentityFile | cut -d ' ' -f 4) --password vagrant inspec_test/locale_de/

test_devsec:
	vagrant up
	LC_MESSAGES=C inspec exec -t ssh://vagrant@$$(vagrant ssh-config | grep HostName | cut -d 'e' -f 2 | cut -d ' ' -f 2):$$(vagrant ssh-config | grep Port | cut -d 't' -f 2 | cut -d ' ' -f 2) -i $$(vagrant ssh-config | grep IdentityFile | cut -d ' ' -f 4) --password vagrant https://github.com/dev-sec/linux-baseline

test: vagrant_box_clean test_inspec
	vagrant destroy --force 2>/dev/null || true

vagrant_box_clean:
	vagrant destroy --force 2>/dev/null || true
	vagrant box remove --force file://builds/$(BASE)/virtualbox-$(BASE).box 2>/dev/null || true


all: clean_all build test
