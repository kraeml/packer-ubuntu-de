# encoding: utf-8
# copyright: 2017, The Authors

# TODO:
# - Test all packages on actual
# -

title 'Desktop Section'

packages = [
  # "ubuntu-desktop",
  "unity-lens-applications",
  "file-roller",
  "gnome-system-monitor"
]

control 'xdesktop' do
  impact 1.0
  title 'OS Family debian/ubuntu, locales and timezone'
  desc "An optional description..."
  packages.each do |package|
    describe package(package) do
      it { should be_installed }
    end
  end
end
