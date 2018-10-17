# encoding: utf-8
# copyright: 2017, The Authors

# TODO:
# - lxc container


title 'DevOps Section'

tools = {
    :vagrant => {
        :version => '2.1.4',
        :command => 'vagrant --version'
    },
    :packer => {
        :version => '1.2.5',
        :command => 'packer --version'
    },
    :ansible => {
        :version => '2.7.0',
        :command => 'ansible --version'
    }
}

gem_packages = [
  "inspec",
  "serverspec",
  "selenium-webdriver",
  "cucumber",
  "rspec",
  "sinatra",
  "rspec-expectations",
  "launchy",
  "rest-client",
  "test-kitchen",
  "kitchen-ansible",
  "kitchen-salt",
  "kitchen-vagrant",
  "kitchen-docker",
  "kitchen-sync",
  "kitchen-verifier-serverspec",
  "kitchen-lxc",
  "kitchen-inspec"
]

# you add controls here
control 'devops' do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title 'DevOps tools setup'                # A human-readable title
  desc 'An optional description...'
  # Installation and version
  tools.each do |key, value|
      if value[:command]
          describe command(value[:command]) do
            its(:stdout) { should match /#{value[:version]}/ }
            if value[:commend]
                its(:stdout) { should match /#{value[:commend]}/ }
            end
          end
      end
  end
  gem_packages.each do |package|
    describe gem(package) do
      it { should be_installed }
    end
  end
end
