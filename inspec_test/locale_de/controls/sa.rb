# encoding: utf-8
# copyright: 2017, The Authors

# Ansible managed: /home/michl/Dokumente/Schule/2_Semester/BSA2/SA_KA/SA2/templates/vagrant-maschine/controls/base.rb

title 'Basis Test der Prüfungsmaschine'

#ToDo Interfaces via Variablen
interfaces = {
  'enp0s3' => {
    'ip' => '10.0.2.15'
  },
  'enp0s3' => {
    'ip' => '10.0.2.15'
  },
  'enp0s3' => {
    'ip' => '10.0.2.15'
  },
  'docker0' => {
    'ip' => '172.17.0.1'
  }
}

control "sa" do
  impact 1.0
  title 'Base Verzeichnisse und Dateien'
  desc 'Basis Test der Maschine'
  describe file('/home/vagrant/dateien') do
    it { should exist }
    it { should be_directory }
  end
  describe file('/home/vagrant/dateien/dnsmasq.conf.example') do
    it { should be_file }
  end
  describe command('hostname') do
    its('stdout') { should match "de"}
  end
  describe interface('enp0s3') do
    it { should be_up }
    #its('ipv4_addresses') { should include '10.0.2.15' }
  end
  interfaces.each do | interface, config|
    describe bash('ip a s ' + interface) do
      its('stdout') { should include config['ip'] }
    end
  end
end
