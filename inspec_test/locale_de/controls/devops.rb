# encoding: utf-8
# copyright: 2017, The Authors

# TODO:
# - lxc container


title 'DevOps Section'

tools = {
    #:vagrant => {
    #    :version => '2.1.4',
    #    :command => 'vagrant --version'
    #},
    :packer => {
        :version => '1.2.5',
        :command => 'packer --version'
    },
    inspec => {
      :version => '4.18.39',
      :command => 'inspec --version'
    },
    :ansible => {
        :version => '2.8.3',
        :command => 'ansible --version'
    }
}

docker_images_ros = [
  "melodic",
  "dashing",
  "kinetic"
]

control 'devops' do
  impact 1.0
  title 'DevOps tools setup'
  desc 'An optional description...'
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
  docker_images_ros.each do |ros|
    describe docker_image("ros:"+ros+"-ros-core") do
      it { should exist }
    end
  end
end
