# encoding: utf-8
# copyright: 2017, The Authors

# TODO:
# - Test git environment
# - Test login shell
# - Test screen config


title 'SA Section'

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
  "dnsutils"
]

control 'sa' do
  impact 1.0
  title 'Base setup'
  desc "An optional description..."
  packages.each do |package|
    describe package(package) do
      it { should be_installed }
    end
  end
end
