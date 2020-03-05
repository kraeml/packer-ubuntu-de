# encoding: utf-8
# copyright: 2017, The Authors

# TODO:
# - Test git environment
# - Test login shell
# - Test screen config


title 'Base Section'

packages = [
  "git",
  "git-flow",
  "build-essential",
  "automake",
  "wget",
  "curl",
  "vim",
  "zsh",
  "fonts-powerline",
  "nano",
  "screen",
  "htop",
  "tree",
  "rsync",
  "sqlite",
  "python3",
  "python",
  "python3-pip",
  "python-pip",
  "python3-virtualenv",
  "python-virtualenv",
  "python3-dev",
  "python-dev",
  "sshpass",
  "avahi-daemon",
  "avahi-utils",
  "nmap",
  "whois",
  "ipcalc",
  "dnsutils",
  "rename"
]

control 'base' do
  impact 1.0
  title 'Base setup'
  desc "An optional description..."
  packages.each do |package|
    describe package(package) do
      it { should be_installed }
    end
  end
  describe file('/home/vagrant/.bash_prompt') do
    it { should be_file }
  end
  describe user('hugo') do
    it { should exist }
    its('uid') { should eq 5000 }
  end
end
