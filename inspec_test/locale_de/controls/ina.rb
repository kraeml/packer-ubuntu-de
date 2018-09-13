# encoding: utf-8
# copyright: 2017, The Authors

# TODO:
# - lxc container


title 'INA Section'

tools = {}

node_packages = [
  "node-red",
  #"express",
  "express-generator",
  "mongoose",
  "vue",
  "vue-cli",
  "mocha",
  "chai",
  "grunt-cli",
  "grunt-init",
  "gulp-cli",
  "npm-check-updates",
  "typescript",
  "ts-node",
  "typings",
  "pm2",
  "socket.io",
  "sqlite3",
  "mysql",
  "javascripting",
  "how-to-npm",
  "scope-chains-closures",
  "stream-adventure",
  "how-to-markdown",
  "learnyouhtml",
  "learnyounode",
  "functional-javascript-workshop",
  "bytewiser",
  "expressworks",
  "bug-clinic",
  "async-you",
  "test-anything",
  "learnyoumongo",
  "torrential",
  "html-validator-cli"
]
packages = [
  "php7.2",
  "mariadb-server",
  "mariadb-client",
  "python-mysqldb",
  "nginx",
  "mongodb"
]

# you add controls here
control 'ina' do                        # A unique ID for this control
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
  node_packages.each do |package|
    describe npm(package, path: '/usr/local/lib/npm/lib') do
      it { should be_installed }
    end
  end
  packages.each do |package|
    describe package(package) do
      it { should be_installed }
    end
  end
  sql = mysql_session('example_user', 'passw0rd')
  describe sql.query('show databases like \'example_db\';') do
    its('stdout') { should_not match(/test/) }
    its('stdout') { should match(/example_db/) }
  end
  describe sql.query('show tables in example_db;') do
    its('exit_status') { should eq(0) }
  end
end
