#
# Cookbook Name:: redmine/
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

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
%w{subversion git application nginx}.each do |recipe|
  include_recipe recipe
end

# install ruby
include_recipe 'redmine::ruby'

# Set up database
include_recipe 'redmine::database'

include_recipe 'redmine::deploy'
