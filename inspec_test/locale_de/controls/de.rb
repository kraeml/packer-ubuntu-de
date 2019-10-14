# encoding: utf-8
# copyright: 2017, The Authors

# TODO:
# - Test all packages on actual
# -

title 'OS Section'

packages = [
  "language-pack-en",
  "language-pack-en-base",
  "language-pack-de",
  "language-pack-de-base",
  "manpages-de"
]

control 'de' do
  impact 1.0
  title 'OS Family debian/ubuntu, locales and timezone'
  desc "An optional description..."
  describe os.family do
    it { should eq 'debian' }
  end
  describe os.name do
    it { should eq 'ubuntu' }
  end
  describe os.release do
     it { should eq '18.04' }
  end
  describe os.arch do
     it { should eq 'x86_64' }
  end
  packages.each do |package|
    describe package(package) do
      it { should be_installed }
    end
  end
  describe file('/etc/localtime') do
    its('link_path') { should eq '/usr/share/zoneinfo/Europe/Berlin' }
  end
  describe command('cat /etc/timezone') do
    its('stdout') {should match 'Europe/Berlin'}
  end
  describe user('hugo') do
    it { should exist }
    its('uid') { should eq 5000 }
  end
end
