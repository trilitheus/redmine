#
# Cookbook Name:: redmine/
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# Needs setting or won't work if using chef-zero or in a bootstrap runlist when behind a proxy
# But problem in vagrant env as Chef::Config[:http_proxy] is not set correctly
# So work around to set manually
svn_prx_host = '10.100.3.135'
svn_prx_port = '3128'
svn_ssl_prx_host = '10.100.3.135'
svn_ssl_prx_port = '3218'
# unless Chef::Config[:http_proxy].nil?
#   ENV['http_proxy'] = URI.parse(Chef::Config[:http_proxy]).to_s
#   svn_prx_host = URI.parse(Chef::Config[:http_proxy]).host
#   svn_prx_port = URI.parse(Chef::Config[:http_proxy]).port
# end

# unless Chef::Config[:http_proxy].nil?
#   ENV['https_proxy'] = URI.parse(Chef::Config[:https_proxy]).to_s
#   svn_ssl_prx_host = URI.parse(Chef::Config[:https_proxy]).host
#   svn_ssl_prx_port = URI.parse(Chef::Config[:https_proxy]).port
# end

# create user and group
group node['redmine']['group']

user node['redmine']['user'] do
  gid node['redmine']['group']
  shell '/bin/bash'
  system true
  supports manage_home: true
  home node['redmine']['home']
end

# Install required packages
node['redmine']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

# include required cookbook recipes
%w{subversion git nginx}.each do |recipe|
  include_recipe recipe
end

# Set up subversion proxy details
# unless Chef::Config[:http_proxy].nil?
  template '/etc/subversion/servers' do
    owner 'root'
    group 'root'
    variables(
      svn_prx_host: svn_prx_host,
      svn_prx_port: svn_prx_port,
      svn_ssl_prx_host: svn_ssl_prx_host,
      svn_ssl_prx_port: svn_ssl_prx_port
    )
  end
# end

# install ruby
include_recipe 'redmine::ruby'

# Set up database
include_recipe 'redmine::database'

# Deploy the redmine application
include_recipe 'redmine::deploy'

# Set up nginx
include_recipe 'redmine::nginx'
