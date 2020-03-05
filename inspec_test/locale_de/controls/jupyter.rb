# encoding: utf-8
# copyright: 2017, The Authors


title 'Jupyter Section'

services = [
    "jupyter",
]


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
    :python3 => {
        :version => '3.6.8',
        :command => 'python3 --version'
    },
    :jupyter => {
        :version => '4.4',
        :command => 'jupyter --version',
        :port => '8888',
        :process => 'jupyter-lab' # This is right without k
    },
    :pip3_jupyter => {
        :version => '1.0',
        :command => 'pip3 show jupyter'
    },
    :pip3_bash_kernel => {
        :version => '0.7.2',
        :command => 'pip3 show bash_kernel'
    },
    :jupyter_bash_kernel => {
        :commend => 'bash',
        :command => 'jupyter-kernelspec list'
    },
    :jupyter_python3 => {
        :commend => 'python3',
        :command => 'jupyter-kernelspec list'
    },
    :jupyter_javascript => {
        :commend => 'javascript',
        :command => 'jupyter-kernelspec list'
    },
    :jupyter_widgets => {
        :commend => 'widgets.*enabled',
        :command => 'jupyter nbextension list'
    },
    :nodejs => {
        :version => '8.16.1',
        :command => 'nodejs -v'
    },
    :npm => {
        :version => '6.4.1',
        :command => 'npm -v'
    }
}

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

control 'users-1.0' do
    impact 1.0
    title 'Ensure users are known'
    desc "An optional description..."
    users.each do |key, value|
        describe user(value[:uname]) do
            it { should exist }
            its('group') { should eq "#{value[:gname]}" }
            its('groups') { should eq value[:groups] }
            its('home') { should eq "#{value[:home]}" }
            #its('shell') { should eq '/bin/bash' }
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
end

# you add controls here
control 'jupyter' do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title 'Jupyter installed and running'                # A human-readable title
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
            # TODO: May use of cmp > version
            # then remove other regex
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
end
