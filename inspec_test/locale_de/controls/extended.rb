# encoding: utf-8
# copyright: 2017, The Authors

# TODO:
# - lxc container


title 'LXC Docker Section'

services = [
    "docker",
]


users = {
    :vagrant => {
      :uname => 'vagrant',
      :gname => 'vagrant',
      :groups => [
	      'vagrant',
        'sudo',
	      'docker'
      ],
      :notGroups => [
        'root'
      ],
      :home => '/home/vagrant'
    }
}

files = {
    :phpinfo => {
        :path => '/var/www/html/index.php',
        :user => 'www-data',
        :group => 'www-data',
        :rights => '0644'
    },
    :ansible_hosts => {
        :path => '/etc/ansible/hosts',
        :user => 'root',
        :group => 'root',
        :rights => '0644'
    }
}

tools = {
    :docker => {
        :version => '18.06',
        :command => 'docker --version'
    }
}

packages = [
  "lxc",
  "lxc-templates",
  "python-lxc",
  "openvswitch-switch",
  "lvm2",
  "btrfs-tools",
  "zfsutils-linux",
  "libvirt-bin",
  "libvirt-dev",
  "python-libvirt",
  "python3-libvirt",
  "virtinst",
  "cgroup-lite",
  "debootstrap",
  "bridge-utils",
  "yum",
  "rpm",
  "qemu-user-static",
  "open-iscsi"
]

control 'files' do
    impact 1.0
    title 'Ensure file/dirs exists'
    desc "An optional description..."
    files.each do |key, value|
        describe file(value[:path]) do
          it { should exist }
        end
    end
end



# you add controls here
control 'extended' do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title 'LXC and Docker installed and running'                # A human-readable title
  desc 'An optional description...'
  for service in services do
      describe systemd_service(service) do
          it { should be_installed }
          it { should be_enabled }
          it { should be_running }
      end
  end
  # Installation and version
  tools.each do |key, value|
      if value[:command]
          describe command(value[:command]) do
            if value[:version]
              its(:stdout) { should cmp >= value[:version] }
            end
            if value[:commend]
                its(:stdout) { should match /#{value[:commend]}/ }
            end
          end
      end
  end
  # Ports are open
  tools.each do |key, value|
      if value[:port]
          describe port(value[:port]) do
            its('processes') { should include value[:process] }
            its('protocols') { should include 'tcp' }
            its('addresses') { should include '0.0.0.0' }
          end
      end
  end
  users.each do |key, value|
      describe user(value[:uname]) do
          it { should exist }
          its('group') { should eq "#{value[:gname]}" }
          #its('groups') { should eq value[:groups] }
          its('home') { should eq "#{value[:home]}" }
          its('shell') { should eq '/bin/bash' }
          #its('mindays') { should eq 0 }
          #its('maxdays') { should eq 90 }
          #its('warndays') { should eq 8 }
      end
      describe command("id #{key.to_s}") do
          value[:groups].each do |group|
              its(:stdout) { should include group.to_s }
          end
          value[:notGroups ].each do |group|
              its(:stdout) { should_not include group.to_s }
          end
      end
  end
  packages.each do |package|
    describe package(package) do
      it { should be_installed }
    end
  end
end
