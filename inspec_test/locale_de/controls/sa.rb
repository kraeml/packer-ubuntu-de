# encoding: utf-8
# copyright: 2017, The Authors

# TODO:
# - Test git environment
# - Test login shell
# - Test screen config


title 'SA Section'

packages = [
  "vim"
]

control 'sa' do
  impact 1.0
  title 'SA setup'
  desc "An optional description..."
  packages.each do |package|
    describe package(package) do
      it { should be_installed }
    end
  end
end
