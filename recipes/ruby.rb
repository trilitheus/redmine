# package or build?
if node['redmine']['ruby_install'] == 'package'
  package 'ruby1.9.3'
else
  include_recipe 'ruby_build'

  ruby_build_ruby '1.9.3-p362' do
    prefix_path '/usr/local/'
    environment 'CFLAGS' => '-g -O2'
    action :install
  end
end

gem_package 'bundler'
